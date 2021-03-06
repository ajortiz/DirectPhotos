//
//  UploadImageViewController.swift
//  phpMySQLTest
//
//  Created by Amanda Ortiz .
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit


class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var albumNameLbl: UILabel!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Album name \(albumName)")
        // Do any additional setup after loading the view.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBOutlet weak var myActivityMonitorIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagePreview: UIImageView!
    
    
   

    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
       imageUploadRequest()
    }
    
    @IBAction func albumRollTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Pro Tip!:" , message: "To save images to your Photo Library, swipe left on any image!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok!", style: .default) { (hand) -> Void in
            let nextScene = self.storyboard?.instantiateViewController(withIdentifier: "albumRollVC")
            self.present(nextScene!, animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
       
        

    }
    @IBAction func selectImageTapped(_ sender: Any) {
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
           
        }//end else
        
        
        //imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePickerController, animated: true, completion:nil)
        
    }
   
    @IBAction func photoLibraryTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion:nil)
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable:Any]!)
    {
        
        imagePreview.contentMode = .scaleAspectFit
        imagePreview.image = image
        self.dismiss(animated: true, completion: nil)
        
    }
 
    
    
    func imageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/uploadImage.php?");
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "albumName"  : albumName,
            "albumID"    : albumID
        ]
        print(albumName)
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        

        let imageData = UIImageJPEGRepresentation(imagePreview.image!, 1)
        
        if(imageData == nil)  {
            let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return;
            
        }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        myActivityMonitorIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json!)
                
                DispatchQueue.main.async(execute: {
                    self.myActivityMonitorIndicator.stopAnimating()
                    self.imagePreview.image = nil;
                });
                
            }catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        
        let filename = String(minutes)+"user-image.jpg"
        print (filename)
        print(albumName)
        let mimetype = "image/jpg"
        
        let modifiedName = albumName.replacingOccurrences(of: "'", with: "%2F'", options: NSString.CompareOptions.literal, range: nil)
        print (modifiedName)
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\";albumName=\"\(modifiedName)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
    
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}




