//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by zenkiu on 10/13/16.
//  Copyright © 2016 zenkiu. All rights reserved.
//


import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController{

    var memes = [Meme]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("in -SentMemeTableViewController- viewWillAppear")
        
        self.title = "Sent Memes"
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        memes=(UIApplication.shared.delegate as! AppDelegate).memes
        
        self.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SentMemeTableViewController.showNewMemeEditor))
        
        self.tableView.reloadData()
        
    }
    
    func showNewMemeEditor(){
        
        print("in show meme editor")
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.present(VC1, animated:true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topTextField
        cell.imageView?.image = meme.memedImage
        
        return cell

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    

}
