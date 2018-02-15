//
//  AlbumRollViewController.swift
//  phpMySQLTest
//
//  Created by Amanda Ortiz on.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit

class AlbumRollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ReloadTable{
    
 
    let URL_GET_ALBUM_IMAGES = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/getAlbumImages.php?"
   
    var currentAlbumName : String!
    
    var imagesDirectoryPath: String!
    var images:[UIImage] = []
    var imageNames = [String]()
    @IBOutlet weak var imageTableView: UITableView!
    @IBOutlet weak var currentAlbumLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTableView.reloadData()
        currentAlbumLbl.text! = String(albumName)
        getAlbumImages()
      
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    //print (currentAlbumName)
    
    
    
    /// ---------------------------------
    // --------- GET ALBUM IMAGES ---------
    /// ---------------------------------
    
    func getAlbumImages()
    {
        let requestURL = NSURL(string: URL_GET_ALBUM_IMAGES)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
      
        
       
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "albumName="+albumName
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
               
                DispatchQueue.main.async(){
                if (myJSON?["images"] == nil)
                {
                    let alertController = UIAlertController(title: "Hold Up!", message: "Album is empty! Upload some pics to get this album started!!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    return

                }
                //parsing the json
                if let parseJSON = myJSON {
                    
                        
                    
                    //getting the json response
                    self.currentAlbumName = parseJSON["albumToLoadName"] as! String?
                    self.imageNames = (parseJSON["images"] as! NSArray) as! [String]
                    //printing the response
                    print ("CURRENT ALBUM NAME")
                    print(self.currentAlbumName)
                    print(self.imageNames)
                    
                    self.refreshTable(passedAlbumName: self.currentAlbumName, imageNamesArray: self.imageNames)
                }
                print("REFRESH TABLE:")
                print(albumName)
                
                print(self.imageNames)
                
                self.currentAlbumLbl.text = albumName
                let modifiedAlbumName = albumName.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
                for imageName in self.imageNames{
                    
                let imageUrlString = "http://www.aortiz6.create.stedwards.edu/directPhotosTEST/albumCatalogue/"+modifiedAlbumName+"/"+imageName
                
                let imageUrl:URL = URL(string: imageUrlString)!
               
                // Start background thread so that image loading does not make app unresponsive
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                   // let imageView = UIImageView(frame: CGRect(x:0, y:0, width:400, height:400))
                    //imageView.center = self.view.center
                    let tempImage = UIImage(data: imageData as Data)
                    // When from background thread, UI needs to be updated on main_queue
                    DispatchQueue.main.async {
                        if let image = tempImage{
                        //imageView.image = image
                        //self.images.append(image!)
                        //imageView.contentMode = UIViewContentMode.scaleAspectFit
                        //self.view.addSubview(imageView)
                        
                        self.images.append(image)
                        self.updateTableView()
                        }
                    }
                }
            }// end for loop
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
       // refreshTable()
        
        

    }
    
    /// ---------------------------------
    // --------- REFERESH TABLE  ---------
    /// ---------------------------------
    func refreshTable(passedAlbumName: String, imageNamesArray: [String]){
        
        print(passedAlbumName)
        print(imageNamesArray)
        

    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PhotoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        cell.itemImage?.image = images[indexPath.row]
               return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func updateTableView() {
        imageTableView.reloadData()
    }

}
class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    
   
    
    var delegate: ReloadTable?
    
    func reloadItemTable () {
        delegate?.updateTableView()
    }
}

protocol ReloadTable {
    func updateTableView()
}
