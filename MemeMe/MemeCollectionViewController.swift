//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Abdalah on 4/24/19.
//  Copyright © 2019 Abdalah. All rights reserved.
//

import UIKit
import Foundation

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    //****************************************
    var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
   
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        /*************************/
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageCollection?.image = meme.memedImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "detailMemeViewController") as! MemeDetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.image = meme.memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    @IBAction func SentMemes(_ sender: Any) {
        let newMemes = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController!.pushViewController(newMemes, animated: true)
    }
    
}
