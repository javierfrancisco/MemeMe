//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by zenkiu on 10/16/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    var meme : Meme!
    
    override func viewWillAppear(_ animated: Bool) {
     
        memeImageView.image = meme.memedImage
        memeImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
}
