//
//  MemeTableViewController.swift
//  ProjectMemeMe
//
//  Created by Jonathan Chinen on 26/12/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes : [Meme]!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnMemeAddedNotification), name: NSNotification.Name(rawValue: memeAddedNotificationKey), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnMemeAddedNotification), name: NSNotification.Name(rawValue: memeAddedNotificationKey), object: nil)
        
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = applicationDelegate.memes
        
        print(self.memes.count)
        print("\t\tTVC appearing...")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\t\tTVC disappearing....")
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // Configure the cell...
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.memedImage

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test")
    }
    
    
    @IBAction func toMemeCreate(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func actOnMemeAddedNotification() {
        self.tableViewOutlet.reloadData()
        NotificationCenter.default.removeObserver(self)
        print("\t\ttableView reloadData")
    }
}
