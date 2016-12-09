//
//  ViewController.swift
//  ProjectMemeMe
//
//  Created by J on 9/12/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var memeTextFieldTop: UITextField!
    @IBOutlet weak var memeTextFieldBottom: UITextField!
    @IBOutlet weak var cameraItemBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var findImageBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var imagePickerImageView: UIImageView!
    
    @IBOutlet weak var shareMemeOutlet: UIBarButtonItem!
    @IBOutlet weak var cancelMemeOutlet: UIBarButtonItem!

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!

    let memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 55)!,
        NSStrokeWidthAttributeName: -5.0
    ]
    
    var activeTextField = UITextField()
    let imagePickerController = UIImagePickerController() //test
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //hide status bar
        UIApplication.shared.isStatusBarHidden = true
        
        //set textField attributes
        memeTextFieldTop.defaultTextAttributes = memeTextAttributes
        memeTextFieldBottom.defaultTextAttributes = memeTextAttributes
        memeTextFieldTop.textAlignment = .center
        memeTextFieldBottom.textAlignment = .center
        
        //dismiss keyboard
        let didTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(didTap)
    
        memeTextFieldTop.delegate = self
        memeTextFieldBottom.delegate = self
        imagePickerController.delegate = self //test
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cameraItemBarButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        checkImagePickerImageViewHasImage()
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
// MARK: TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func topTextFieldIsEditing() -> Bool {
        if self.activeTextField == memeTextFieldTop {
            return true
        } else {
            return false
        }
    }

// MARK: Keyboard Control
    func dismissKeyboard() {
        view.endEditing(true)
        view.frame.origin.y = 0
    }

    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if topTextFieldIsEditing() {
           view.frame.origin.y = 0
        } else {
            view.frame.origin.y = 0 - getKeyboardHeight(notification as Notification)
        }
    }
    
    func keyboardWillHide(notificaiton: NSNotification) {
        dismissKeyboard()
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
// MARK: ToolBar - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func presentImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func findAnImage() {
        imagePickerController.sourceType = .photoLibrary
        presentImagePickerController()
    }
    
    @IBAction func cameraAnImage() {
        imagePickerController.sourceType = .camera
        presentImagePickerController()
    }
    
// MARK: NavBar - Share / Cancel
    @IBAction func shareMeme(_ sender: Any) {
    let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //prevents iPads from crashing:
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.completionWithItemsHandler = {
            activity, completed, items, error in
            if (activity == UIActivityType.message && completed) {
                self.save()
                //test
                let messageAlert = UIAlertController(title: "", message: "Meme Sent!", preferredStyle: UIAlertControllerStyle.alert)
                messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                }))
                self.present(messageAlert, animated: true, completion: nil)
                //endTest
            } else {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: UIBarButtonItem!) {
        imagePickerImageView.image = nil
        memeTextFieldTop.text = "TOP"
        memeTextFieldBottom.text = "BOTTOM"
    }
    
    func checkImagePickerImageViewHasImage() {
        if imagePickerImageView.image == nil {
            shareMemeOutlet.isEnabled = false
            cancelMemeOutlet.isEnabled = false
        } else {
            shareMemeOutlet.isEnabled = true
            cancelMemeOutlet.isEnabled = true
        }
    }

// MARK: Create Meme
    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
    func save() {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: memeTextFieldTop.text!, bottomText: memeTextFieldBottom.text!,
                        originalImage: imagePickerImageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        navBar.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(imagePickerImageView.frame.size, false, 0.0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        navBar.isHidden = false
        toolBar.isHidden = false
        return memedImage
    }
}
