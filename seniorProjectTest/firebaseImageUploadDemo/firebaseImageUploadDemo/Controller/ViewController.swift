//
//  ViewController.swift
//  firebaseImageUploadDemo
//
//  Created by Amanda Ortiz on 11/13/17.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class ViewController: UIViewController {

    var refAlbums: FIRDatabaseReference!
    var albumID = String()
    let toolBoxController: toolBox = toolBox()
    
    
    @IBOutlet weak var albumEmail_Input: UITextField!
    @IBOutlet weak var albumName_Input: UITextField!
    @IBOutlet weak var createAlbum_Btn: UIButton!

    @IBOutlet weak var email_Input: UITextField!
    @IBOutlet weak var password_Input: UITextField!
    
    @IBOutlet weak var accountCreationStatus_Lbl: UILabel!
    
    override func viewDidLoad() {
        refAlbums = FIRDatabase.database().reference().child("albums")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func addAlbum(){
        let key = refAlbums.childByAutoId().key
        let albumAccessKey = toolBoxController.randomString(length: 4)
        let album = [
            "id": key,
            "albumName": albumName_Input.text!,
            "albumAccessKey": albumAccessKey ]
        albumID = key
        refAlbums.child(key).setValue(album)
        
       
        
    }
    
    
    
    @IBAction func didTapCreateAlbum_Btn(_ sender: Any) {
        print("IN DID TAP CREATE ALBUM: ")
        print(albumName_Input.text!)
 
        
    }
    
   @IBAction func didTapCreateAccount_Btn(_ sender: Any) {
        if email_Input.text! == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: email_Input.text!, password: password_Input.text!) { (user, error) in
                
                if error == nil {
                    print("\n You have successfully signed up \n")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    self.accountCreationStatus_Lbl.text = "Account Susccessfully Created"
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "usrHomeVC")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUploadVC" {
            if albumEmail_Input.text! == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            }
            addAlbum()
            let alertController = UIAlertController(title: "Success!", message: "Album has been created, your album key has been emailed to you.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            if let viewController = segue.destination as? uploadManager_ViewController {

                viewController.albumName = albumName_Input.text!
                viewController.albumID = albumID
                
                print("album ID : " + albumID)
                

            }
        }}
    
    
}

