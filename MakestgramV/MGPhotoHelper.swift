//
//  MGPhotoHelper.swift
//  MakestgramV
//
//  Created by Thomas on 2017/7/24.
//  Copyright © 2017年 Thomas. All rights reserved.
//

import Foundation
import UIKit

class MGPhotoHelper : NSObject{
    // MARK: - Properties
    
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    func presentActionSheet(from viewController: UIViewController) {
        // Initialize a new UIAlertController of type actionSheet. 
        //UIAlertController can be used to present different types of alerts.
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        // Check if the current device has a camera available.
        // Simulator does not have one
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Create a new UIAlertAction.
            //Each UIAlertAction represents an action on the UIAlertController
            //As part of the UIAlertAction initializer, you can provide a title, style, and handler that will execute when the action is selected.
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                //call
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            
            // Add the action to the alertController instance we created.
            alertController.addAction(capturePhotoAction)
        }
        
        // Repeat the previous sets 2-4 for the user's photo library.
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            
            alertController.addAction(uploadAction)
        }
        
        // Add a cancel action to allow an user to close the UIAlertController action sheet. Notice that the style is .cancel instead of .default.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the UIAlertController from our UIViewController
        viewController.present(alertController, animated: true)
    }
    // Alow to take pics
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        
        //We create a new instance of UIImagePickerController.
        //This object will present a native UI component that will allow the user to take a photo from the camera or choose an existing image from their photo library.
        let imagePickerController = UIImagePickerController()
        
        //to determine whether the UIImagePickerController will activate the camera and display a photo taking overlay or show the user's photo library. 
        //The sourceType is specified by the argument passed into the function.
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        //Last, after our imagePickerController is initialized and configured, we present the view controller.

        viewController.present(imagePickerController, animated: true)
    }
}
//We implement two different delegate methods: One is called when an image is selected, the other is called when the cancel button is tapped.
extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
