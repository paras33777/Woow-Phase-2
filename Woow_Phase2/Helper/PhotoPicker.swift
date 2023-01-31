//
//  PhotoPicker.swift
//  PointPay
//
//  Created by Rahul Chopra on 09/11/20.
//  Copyright © 2020 AppSmall. All rights reserved.
//

import Foundation
import UIKit

class PhotoPicker: NSObject {
    
    static let shared = PhotoPicker()
    let imagePicker = UIImagePickerController()
    var closureDidGetImage: ((UIImage) -> ())?
    
    
    // MARK:- CORE FUNCTIONALITIES
    func showPicker() {
        Alert.show(message: AlertString.chooseImageMethod, actionTitle1: AlertString.camera, actionTitle2: AlertString.photoLibrary, actionTitle3: AlertString.cancel, cancelIndex: 2, alertStyle: .actionSheet, completionOK: {
            self.openCamera()
        }) {
            self.openPhotoLibrary()
        }
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            UIApplication.rootViewController().present(imagePicker, animated: true, completion: nil)
        } else {
            Alert.showSimple("Your device doesn't support camera")
        }
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            UIApplication.rootViewController().present(imagePicker, animated: true, completion: nil)
        } else {
            Alert.showSimple("Your device doesn't support photo library")
        }
    }
    
}


// MARK:- IMAGE PICKER CONTROLLER DELEGATE METHODS
extension PhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UIApplication.rootViewController().dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage!
        if let origImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = origImage
        }
        
        if closureDidGetImage != nil {
            self.closureDidGetImage!(image)
        }
        
        UIApplication.rootViewController().dismiss(animated: true, completion: nil)
    }
}


struct AlertString {
    static let doYouWantToLogout = "Do you want to logout?"
    static let yes = "Yes"
    static let no = "No"
    static let cancel = "Cancel"
    
    static let chooseImageMethod = "Choose Image Method"
    static let camera = "Camera"
    static let photoLibrary = "Photo Library"
}

