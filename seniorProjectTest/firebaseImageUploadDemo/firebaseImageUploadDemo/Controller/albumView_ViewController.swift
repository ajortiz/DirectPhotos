//
//  AlbumView_ViewController.swift
//  firebaseImageUploadDemo
//
//  Created by Amanda Ortiz on 11/25/17.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase

class albumView_ViewController: UIViewController,UINavigationControllerDelegate {

    var databaseChildName = String()
    var albumName = String()
    var dbRefLink: FIRDatabaseReference!
    var storage: FIRStorage!
    
    @IBOutlet weak var albumName_Lbl: UILabel!
    

    // Initialize an array for your pictures
    var picArray = [UIImage]()
    
    override func viewDidLoad() {
        // Initialize Database, Auth, Storage
        albumName_Lbl.text? = albumName
        dbRefLink = FIRDatabase.database().reference().child("albums")
        storage = FIRStorage.storage()
        
        //loadImages()
        
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages()
    {
        print(databaseChildName)
        let dbRef = self.dbRefLink.child(databaseChildName)
        dbRef.observe(.childAdded, with: { (snapshot) in
            // Get download URL from snapshot
            let downloadURL = snapshot.value as! String
            // Create a storage reference from the URL
            let storageRef = self.storage.reference(forURL: downloadURL)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                self.picArray.append(pic!)
                print("inside loadImages")
            }
        })
        

    } //end loadImages
        
}
