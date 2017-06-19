//
//  ViewController.swift
//  memeMe
//
//  Created by Drew Fleeman on 5/28/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var userEnteredTop: Bool = false
    var userEnteredBottom: Bool = false
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.saveMeme(memeImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
//        for devices that use popoverPresentationControllers
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func saveMeme(memeImage: UIImage) {
        if let top = topText.text, let bottom = bottomText.text, let image = imageView.image {
            _ = Meme(topText: top, bottomText: bottom, image: image, memedImage: memeImage)
        }
    }
    
    func generateMemedImage() -> UIImage {
        // Hide the navigation bar and toolbar
        toggleBars(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show Nav and Toolbar
        toggleBars(isHidden: false)
        
        return memedImage
    }
    
    private func toggleBars(isHidden: Bool) {
        navBar.isHidden = isHidden
        toolbar.isHidden = isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        topText.backgroundColor = UIColor.clear
        bottomText.backgroundColor = UIColor.clear

        shareButton.isEnabled = false
        
        setTextAttribute(textField: topText, str: "TOP")
        setTextAttribute(textField: bottomText, str: "BOTTOM")
    }
    
    //Attributes for styling the text in the text fields
    let memeTextAttribues = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName : NSNumber(value: -3.0)
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func pickImageFromAlbum(_ sender: UIBarButtonItem) {
        pickImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        pickImage(sourceType: .camera)
    }
    
    private func pickImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomText.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomText.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    // image picker methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    // navigation controller methods
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    // text field methods
    
    // General method to set both textField attributes
    func setTextAttribute(textField : UITextField, str : String) {
        textField.delegate = self
        textField.text = str
        textField.defaultTextAttributes = memeTextAttribues
        textField.textAlignment = .center
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (!userEnteredTop && textField == topText) {
            topText.text = ""
            userEnteredTop = true
        } else if (!userEnteredBottom && textField == bottomText) {
            bottomText.text = ""
            userEnteredBottom = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == topText && topText.text == "" {
            topText.text = "TOP"
        } else if textField == bottomText && bottomText.text == "" {
            bottomText.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

