//
//  StorageService.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/25.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageService {
    // Upload Images
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // change the image from an UIImage to Data and reduce the quality of the image.
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        // We upload our media data to the path provided as a parameter to the method.
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // After the upload completes, we check if there was an error.
            if let error = error {
                //assertFailure will crash the app and print the error
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // If everything was successful, we return the download URL for the image.
            completion(metadata?.downloadURL())
        })
    }
}
