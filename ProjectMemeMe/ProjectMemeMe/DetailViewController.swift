//
//  DetailViewController.swift
//  ProjectMemeMe
//
//  Created by Jonathan Chinen on 4/1/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var memes : Meme!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        self.imageViewOutlet.image = self.memes.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
