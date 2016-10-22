//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by zenkiu on 10/13/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController{
    
    
  
    
    var memes = [Meme]()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sent Memes"
        
        let space: CGFloat = 0.0
        
        let dimension =  (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("in -SentMemeCollectionViewController- viewWillAppear")
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        memes=(UIApplication.shared.delegate as! AppDelegate).memes
        
        self.navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SentMemeCollectionViewController.showNewMemeEditor))
        
         self.collectionView?.reloadData()
    }
    
    func showNewMemeEditor(){
        
        //print("in show meme editor")
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.present(VC1, animated:true, completion: nil)
    }
    
    
    // Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // print("number of memes: \(memes.count)")
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("-in cellForItemAtIndexPath-")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath as IndexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        
        // Set the name and image
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView.contentMode=UIViewContentMode.scaleAspectFit
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // print("-in didSelectItemAtIndexPath-")
        
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
  

}
