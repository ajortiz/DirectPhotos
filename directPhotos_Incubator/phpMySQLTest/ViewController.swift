//
//  ViewController.swift
//  phpMySQLTest
//
//  Created by Amanda Ortiz.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit

var albumID: String = ""
var albumName: String = ""
var loggedInPath: String = ""
var albumKey : String = ""

class ViewController: UIViewController {
    //URL to our web service
    let URL_SAVE_NEW_MEMBER = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/createUser.php?"
    let URL_SAVE_GET_MEMBER = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/loginUser.php?"
    let URL_CREATE_NEW_ALBUM = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/createAlbum.php?"
     let URL_GET_ALBUM = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/getAlbum.php?"

    //let HelperClass = new Helper()
    //TextFields declarations
  //  @IBOutlet weak var newEmailText: UITextField!
    //@IBOutlet weak var newPasswordText: UITextField!
    //creating a string
    var user_id : String!
   
  /*
    // LOGIN Button action method
    @IBAction func buttonLogin(_ sender: Any) {
        //created NSURL
        let requestURL = NSURL(string: URL_SAVE_GET_MEMBER)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let newEmail = (newEmailText.text!)
        let newPassword = (newPasswordText.text!)
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "email="+newEmail+"&password="+newPassword
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
           // print("DATA ", String(data: data!,encoding: .utf8) as Any)
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try
                    JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    
                    
                    //getting the json response
                    self.user_id = parseJSON["user_id"] as! String?
                    
                    //printing the response
                    print ("CURRENT USER ID")
                    print(self.user_id)
                }
                
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
       
        
    
    }// end login function
    
   */
    
    
// ----- CREATE NEW ACCOUNT --------
    
    //SAVE Button action method
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/// ---------------------------------
// --------- CREATE ALBUM -----------
/// ---------------------------------

    @IBOutlet weak var newKeyLbl: UILabel!
    @IBOutlet weak var newAlbumName: UITextField!
    @IBOutlet weak var emailAddressText: UITextField!
    
    
    
    @IBAction func tappedCreateAlbumBtn(_ sender: Any) {
        
        //created NSURL
        let requestURL = NSURL(string: URL_CREATE_NEW_ALBUM)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let newAlbum=newAlbumName.text
        let emailAddress=emailAddressText.text
        let newKey=generateKey(length: 4)
        
        Helper().createEmailAccount(emailToRegister: emailAddress!)
        print(newKey)
        
        
        //let modifiedNewAlbumName = newAlbum?.replacingOccurrences(of: "\'", with: "", options: NSString.CompareOptions.literal, range: nil)
        //creating the post parameter by concatenating the keys and values from text field
        //let modifiedNewAlbumName2 = modifiedNewAlbumName?.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
       // print (modifiedNewAlbumName2!)
        //let modifiedName = newAlbum?.replacingOccurrences(of: "\'", with: "\\'", options: NSString.CompareOptions.literal, range: nil)
        let postParameters = "albumName="+newAlbum!+"&albumKey="+newKey+"&albumPath=albumCatalogue/"+newAlbum!+"&emailAddress="+emailAddress!
        print (postParameters)
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
                    DispatchQueue.main.async(){

                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    if(msg == "Album Created Successfully")
                    {
                        let alertController = UIAlertController(title: "Success!", message: "Album Created, your album key has been emailed to you, and placed in the login text field for your convenience! Get sharing!", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        self.newKeyLbl.text = newKey
                        self.albumLoginText.text = newKey
                        return

                   }
                    else
                    {
                            let alertController = UIAlertController(title: "Failure!", message: "Album was not created, please make sure to only user Alpha and Numeric characters ~ no special characters pls.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                            
                            return
                            
                    }

                }// end dispatch
                }//end if let
            } catch {
                print(error)
            }
            
        }// end let task
        //executing the task
        task.resume()
        
    }
    
    /// ---------------------------------
    // --------- GENERATE KEY  ---------
    /// ---------------------------------
    func generateKey(length: Int) -> String {
        let keyChoices = "ABCDEFGHIJKLMNOPQRSTUVWZXY1234567890"
        var newKey = ""
        for _ in 0...length {
            newKey += String(keyChoices[keyChoices.index(keyChoices.startIndex, offsetBy: Int(arc4random_uniform(UInt32(keyChoices.characters.count))))])
        }
        return newKey
    }
 
/// ---------------------------------
// --------- LOGIN TO ALBUM ---------
/// ---------------------------------
    
    @IBOutlet weak var albumLoginText: UITextField!
    @IBAction func didTapUploadToAlbum(_ sender: Any) {
       
        //created NSURL
        let requestURL = NSURL(string: URL_GET_ALBUM)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        //let loginAlbumKey =
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "albumKey="+(albumLoginText.text!)
        print(postParameters)
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                
                return;
            }
            print("DATA ", String(data: data!,encoding: .utf8) as Any)
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try
                    JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                 DispatchQueue.main.async(){
                
                
                if (myJSON == nil) {
                    let alertController = UIAlertController(title: "Access Denied", message: "album does not exist", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    return

                }
                //parsing the json
                if let parseJSON = myJSON {
                    print ("parsed \(parseJSON)")
                   
                    //getting the json response
                    albumKey = (parseJSON["album_key"] as! String?)!
                    albumID = (parseJSON["album_id"] as! String?)!
                    albumName = (parseJSON["album_name"] as! String?)!
                    loggedInPath = (parseJSON["album_path"] as! String?)!
                    
                    //printing the response
                    print ("CURRENT ALBUM ID")
                    print(albumID)
                    print ("Album name: \(albumName)")
                    
                    let goToUploadVC = self.storyboard?.instantiateViewController(withIdentifier: "uploadImageVC") as! UploadImageViewController
                    self.present(goToUploadVC, animated: true, completion: nil)
                }
                }
                
            } catch {
                print(error)
            }
        }
     
        //executing the task
        task.resume()
        
             
  
    }
    
}

