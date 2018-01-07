//
//  Homestay_final+extension.swift
//  HMS-Express
//
//  Created by Ding Zhan on 29/12/2017.
//  Copyright © 2017 Ding Zhan Chia. All rights reserved.
//

import UIKit
import Photos

extension Homestay_final : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func handlerSelectProfileImageView(_ sender : AnyObject){
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            present(picker,animated : true,completion:nil)
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // alert box please and then go to seting
            let alertController = UIAlertController(title: "Plase Allow Access to your Photos" , message: "", preferredStyle: .alert)
            
            // Confirmation Action. Date: 30 Sept 2017
            let confirmAction = UIAlertAction(title: "Settings", style: .default , handler: { (action)-> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!)!
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            })
            // Cancelation Action
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            // Add 2 Actions
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
            
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    self.present(picker,animated : true,completion:nil)
                } else {
                }
            })
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        print(list_of_image.count)
        list_of_image.append(selectedImageFromPicker!)
        print(list_of_image.count)
        self.picture_collection.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
