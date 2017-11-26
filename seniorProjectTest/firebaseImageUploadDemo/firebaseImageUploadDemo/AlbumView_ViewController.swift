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

class AlbumView_ViewController: UIViewController {

    var databaseChildName = String()
    var database: FIRDatabase!
    var storage: FIRStorage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    let dbRef = database.reference().child(databaseChildName)
//    dbRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
//    // Get download URL from snapshot
//    let downloadURL = snapshot.value() as! String
//    // Create a storage reference from the URL
//    let storageRef = storage.referenceFromURL(downloadURL)
//    // Download the data, assuming a max size of 1MB (you can change this as necessary)
//    storageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
//    // Create a UIImage, add it to the array
//    let pic = UIImage(data: data)
//    picArray.append(pic)
//    })
//    })

}
