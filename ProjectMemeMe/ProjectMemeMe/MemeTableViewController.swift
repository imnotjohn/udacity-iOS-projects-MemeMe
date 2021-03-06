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
    var didMeme : Bool!
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didMeme = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = applicationDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (didMeme == true) {
            tableViewReload()
            didMeme = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activateDidMemeListener()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        // Configure the cell...
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.memedImage

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.memes = memes[((indexPath as? NSIndexPath)?.row)!]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            
            self.tableViewOutlet.beginUpdates()
            appDelegate.memes.remove(at: indexPath.row) //appdelegate stored memes
            memes = appDelegate.memes //tableview stored meme values
            tableViewReload()
            self.tableViewOutlet.deleteRows(at: [indexPath], with: .fade)
            self.tableViewOutlet.endUpdates()
            notifyMemeDeleted()
        }
    }
    
    func tableViewReload() {
        tableViewOutlet.reloadData()
    }
    
    func actOnMemeAddedNotification() {
        didMeme = true
        NotificationCenter.default.removeObserver(self)
    }
    
    func activateDidMemeListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnMemeAddedNotification), name: NSNotification.Name(rawValue: memeAddedNotificationKey), object: nil)
    }
    
    func notifyMemeDeleted() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: memeAddedNotificationKey), object: self)
    }
}
