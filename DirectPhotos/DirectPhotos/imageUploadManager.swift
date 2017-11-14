//
//  imageUploadManager.swift
//  DirectPhotos
//
//  Created by Amanda Ortiz on 11/13/17.
//  Copyright © 2017 aortiz6. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class imageUploadManager: NSObject {
    func uploadImage(_ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        let storage = FIRStorage.storage()
        let storageReference = storage.reference()
        
        // storage/albumImages/image.jpg
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imagesReference = storageReference.child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imagesReference.put(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
    }
}
