//
//  uploadManage_ViewController.swift
//  firebaseImageUploadDemo
//
//  Created by Amanda Ortiz on 11/13/17.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class uploadManager_ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var imagePreview: UIImageView!
    var albumName = String()
    var albumID = String()
    
    override func viewDidLoad() {
      
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func uploadImageTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //if camera is available..
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
            //if front camera is available...
            if UIImagePickerController.isCameraDeviceAvailable(.front){
                //use front
                imagePickerController.cameraDevice = .front
            }//end inside if
                //if rear camera is available..
            else{
                //use rear
                imagePickerController.cameraDevice = .rear
            }//end else
        }// end whole if camera is available
            //if no camera available...go to photo album
        else{
            imagePickerController.sourceType = .photoLibrary
        }//end else
        
        
        //imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePickerController, animated: true, completion:nil)
        
    }
    
    
    @objc(imagePickerController:didFinishPickingMediaWithInfo:) func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
       
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imagePreview.contentMode = .scaleAspectFit
            imagePreview.image = image
            activityMonitor.startAnimating()
        }
        else
        {
            //error
        }
        
        self.dismiss(animated: true, completion: nil)
        let imageName = randomString(length: 5)
        
        print (albumID + "/" + imageName + ".png")
        let storageRef = FIRStorage.storage().reference().child(albumID + "/" + imageName + ".png")
        if let uploadData = UIImagePNGRepresentation(self.imagePreview.image!){
            storageRef.put(uploadData, metadata: nil, completion:
                {
                    (metadata, error) in
                    if error != nil {
                        print("error")
                        
                        return
                    }
                    else{
                    self.activityMonitor.stopAnimating()

                        print("Upload successful")
                    }
                    
                    print(metadata)
            }
            )
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumView" {
            if let viewController = segue.destination as? AlbumView_ViewController {
                viewController.databaseChildName = albumID
                
            }
        }}
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

}
