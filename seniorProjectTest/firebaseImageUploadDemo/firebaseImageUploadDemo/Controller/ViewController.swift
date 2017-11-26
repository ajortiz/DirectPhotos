//
//  ViewController.swift
//  firebaseImageUploadDemo
//
//  Created by Amanda Ortiz on 11/13/17.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewController: UIViewController {

    var refAlbums: FIRDatabaseReference!
    var albumID = String()
    let toolBoxController: toolBox = toolBox()
    
    
    @IBOutlet weak var albumName_Input: UITextField!
    @IBOutlet weak var createAlbum_Btn: UIButton!

    
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
            //randomString(length: 4)
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
        addAlbum()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUploadVC" {
            if let viewController = segue.destination as? uploadManager_ViewController {

                viewController.albumName = albumName_Input.text!
                viewController.albumID = albumID
                
                print("album ID : " + albumID)
                

            }
        }}
    
    
}

