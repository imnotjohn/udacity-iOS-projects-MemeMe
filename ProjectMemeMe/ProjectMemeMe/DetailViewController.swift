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

        // Do any additional setup after loading the view.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            let controller = (segue.destinationViewController as! UINavigationController.topViewController as! DetailViewController)
//            let row = (sender as! NSIndexPath).row
//            let detail = memes[row] as! DetailViewController
            print("Did Segue")
    }

}
