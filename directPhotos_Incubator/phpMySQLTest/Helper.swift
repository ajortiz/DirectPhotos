//
//  Helper.swift
//  File contains helper methods used in other classes
//  phpMySQLTest
//
//  Created by Amanda Ortiz on 2/17/18.
//  Copyright © 2018 aortiz6. All rights reserved.
//

import UIKit

class Helper: UIViewController {
    let URL_SAVE_NEW_MEMBER = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/createUser.php?"
    let URL_SAVE_GET_MEMBER = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/loginUser.php?"
    let URL_CREATE_NEW_ALBUM = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/createAlbum.php?"
    let URL_GET_ALBUM = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/getAlbum.php?"
    
    
    
    func createEmailAccount(emailToRegister: String) {
        //created NSURL
        let requestURL = NSURL(string: URL_SAVE_NEW_MEMBER)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        //let newEmail=newEmailText.text
        //let newPassword = newPasswordText.text
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "email="+emailToRegister
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
    }
    

}
