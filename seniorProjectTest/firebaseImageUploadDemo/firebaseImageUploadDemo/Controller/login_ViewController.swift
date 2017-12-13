//
//  login_ViewController.swift
//  firebaseImageUploadDemo
//
//  Created by Amanda Ortiz on 12/13/17.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class login_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var loginEmail_Input: UITextField!
    @IBOutlet weak var loginPassword_Input: UITextField!
    
    
    @IBAction func didTapLogin_Btn(_ sender: Any) {
        if self.loginEmail_Input.text == "" || self.loginPassword_Input.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.loginEmail_Input.text!, password: self.loginPassword_Input.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    
                
                   let vc = self.storyboard?.instantiateViewController(withIdentifier:"usrHomeVC")
                    
                    
                self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
