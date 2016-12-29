//
//  MemeCollectionViewController.swift
//  ProjectMemeMe
//
//  Created by Jonathan Chinen on 26/12/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "memeCollectionCell"

class MemeCollectionViewController: UICollectionViewController {

    var memes : [Meme]!
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(MemeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnMemeAddedNotification), name: NSNotification.Name(rawValue: memeAddedNotificationKey), object: nil)
        
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = applicationDelegate.memes
        
        print(memes)
        print("\t\tCV appearing....")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\t\tCV disappearing....")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        // Configure the cell...
//        cell.textLabel?.text = meme.topText + meme.bottomText
        cell.cellImageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collection view")
    }

    func actOnMemeAddedNotification() {
        self.collectionViewOutlet.reloadData()
//        collectionView?.reloadData()
        NotificationCenter.default.removeObserver(self)
        print("\t\tcollectionView reloadData")
    }
}
