//
//  userHome_ViewController.swift
//  firebaseImageUploadDemo
//
//  Created by Amanda Ortiz on 12/13/17.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class userHome_ViewController: UIViewController {
    let user = FIRAuth.auth()?.currentUser
    var uid = String()
    //  var emailVerified = Bool
    
    //emailVerified = user.emailVerified;
   
    
    @IBOutlet weak var usrID_Lbl: UILabel!
    
    override func viewDidLoad() {
         uid = (user?.uid)!
        usrID_Lbl.text = uid
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout_Btn(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

}
