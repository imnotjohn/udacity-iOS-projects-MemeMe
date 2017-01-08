//
//  MemeCreatorViewController.swift
//  ProjectMemeMe
//
//  Created by J on 9/12/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

//test
let memeAddedNotificationKey = "com.Udacity.ProjectMemeMe.memeAddedNotificationKey"

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, ModalViewControllerDelegate {
    
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
    let imagePickerController = UIImagePickerController()
    
    var orientation = UIDevice.current.orientation
    var currentWidth : CGFloat!
    var currentHeight : CGFloat!
    var currentFrame : CGRect!
    var scaledImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //hide status bar
        UIApplication.shared.isStatusBarHidden = true
        
        //set textField attributes
        setDefaultTextAttributes(textField: memeTextFieldTop)
        setDefaultTextAttributes(textField: memeTextFieldBottom)
        
        //dismiss keyboard
        let didTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(didTap)

        imagePickerController.delegate = self
        
        self.modalPresentationStyle = UIModalPresentationStyle.custom
    }
    
    func setDefaultTextAttributes(textField : UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cameraItemBarButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        checkImagePickerImageViewHasImage()
        subscribeToKeyboardNotifications()
        
        self.tabBarController?.tabBar.isHidden = true //test
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
// MARK: - Determine Orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: ({(context) -> Void in
            self.getRatioWH()
        }), completion: nil)
    }
    
    func getRatioWH() {
        imagePickerImageView.contentMode = .scaleAspectFit
        
        currentWidth = UIScreen.main.bounds.width
        currentHeight = UIScreen.main.bounds.height
        currentFrame = CGRect(x: 0, y: 0, width: currentWidth, height: currentHeight)
    }

// MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        textField.allowsEditingTextAttributes = true
    }
    
    func topTextFieldIsEditing() -> Bool {
        if self.activeTextField == memeTextFieldTop {
            return true
        } else {
            return false
        }
    }

// MARK: - Keyboard Control
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        if topTextFieldIsEditing() {
           view.frame.origin.y = 0
        } else {
            view.frame.origin.y = -getKeyboardHeight(notification as Notification)
        }
    }
    
    func keyboardWillHide(_ notificaiton: NSNotification) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
// MARK: - ToolBar - Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let rect = AVMakeRect(aspectRatio: image.size, insideRect: imagePickerImageView.bounds)
            UIGraphicsBeginImageContextWithOptions(imagePickerImageView.frame.size, false, 0.0)
            image.draw(in: rect)
            scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            imagePickerImageView.image = scaledImage
            UIGraphicsEndImageContext()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func presentImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func findAnImage(sender : UIBarButtonItem!) {
        switch sender.tag {
        case 0:
            imagePickerController.sourceType = .photoLibrary
            presentImagePickerController()
        default:
            imagePickerController.sourceType = .camera
            presentImagePickerController()
        }
        }
    
    @IBAction func changeRender() {
        navBar.isHidden = !navBar.isHidden
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {return}
        
        switch segueID {
        case "modalSegue":
            let destVC = segue.destination as! ModalViewController
            destVC.modalDelegate = self
            break
        default:
            break
        }
    }
    
    func sendValue(value: NSString) {
        memeTextFieldTop.font = UIFont(name: value as String, size: 55)!
        memeTextFieldBottom.font = UIFont(name: value as String, size: 55)!
    }
    
// MARK: - NavBar - Share / Cancel
    @IBAction func shareMeme(_ sender: Any) {
        getRatioWH()
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //prevents iPads from crashing:
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.completionWithItemsHandler = {
            activity, completed, items, error in
            if (completed) {
                self.save()
                self.notifyMemeAdded()
                self.displayMessageAlert()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func displayMessageAlert() {
        let messageAlert = UIAlertController(title: "", message: "Meme Sent!", preferredStyle: UIAlertControllerStyle.alert)
        messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(messageAlert, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: UIBarButtonItem!) {
        imagePickerImageView.image = nil
        memeTextFieldTop.text = "TOP"
        memeTextFieldBottom.text = "BOTTOM"
        
        UIGraphicsEndImageContext() 
        checkImagePickerImageViewHasImage()
        self.dismiss(animated: true, completion: nil) 
    }
    
    func checkImagePickerImageViewHasImage() {
        if imagePickerImageView.image == nil {
            shareMemeOutlet.isEnabled = false
        } else {
            shareMemeOutlet.isEnabled = true
        }
    }
    
    func save() {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: memeTextFieldTop.text!, bottomText: memeTextFieldBottom.text!,
                        originalImage: imagePickerImageView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        navBar.isHidden = true
        toolBar.isHidden = true

        getRatioWH()

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: currentFrame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        navBar.isHidden = false
        toolBar.isHidden = false
        return memedImage
    }
    
    func notifyMemeAdded() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: memeAddedNotificationKey), object: self)
    }
}

