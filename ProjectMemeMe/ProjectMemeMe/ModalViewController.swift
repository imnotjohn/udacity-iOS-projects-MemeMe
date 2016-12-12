//
//  ModalViewController.swift
//  ProjectMemeMe
//
//  Created by J on 12/12/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate {
    func sendValue(value : NSString)
}

class ModalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var currentFontName = ["Impact", "Courier-Bold", "ChalkboardSE-Bold"]
    var modalDelegate : ModalViewControllerDelegate?

    @IBOutlet weak var fontPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fontPickerView.delegate = self //test
        fontPickerView.dataSource = self //test
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentFontName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentFontName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let fontNameData = currentFontName[row]
        let pickerViewAttributedString = NSAttributedString(string: fontNameData, attributes: [NSForegroundColorAttributeName : UIColor.white])
        return pickerViewAttributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        memeTextFieldTop.font = UIFont(name: currentFontName[row], size: 55)!
        //        memeTextFieldBottom.font = UIFont(name: currentFontName[row], size: 55)!
        if let del = modalDelegate {
            del.sendValue(value: currentFontName[row] as NSString)
        }
    }
    
    @IBAction func doneSelectingFont(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
