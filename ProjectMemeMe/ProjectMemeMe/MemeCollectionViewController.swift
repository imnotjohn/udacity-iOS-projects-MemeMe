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
    var orientation = UIDeviceOrientation.portrait
    
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space : CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2*space)) / 3.0
        
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnMemeAddedNotification), name: NSNotification.Name(rawValue: memeAddedNotificationKey), object: nil)
        
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = applicationDelegate.memes
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]

        // Configure the cell...
        cell.cellImageView?.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.memes = memes[((indexPath as? NSIndexPath)?.row)!]
        self.navigationController!.pushViewController(detailController, animated: true)
        print("I exist")
    }

    func actOnMemeAddedNotification() {
        self.collectionView?.reloadData()
        NotificationCenter.default.removeObserver(self)
    }
}
