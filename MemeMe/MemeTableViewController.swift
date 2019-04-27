//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Abdalah on 4/24/19.
//  Copyright © 2019 Abdalah. All rights reserved.
//

import UIKit
import Foundation

class MemeTableViewController: UITableViewController {
    var memes: [Meme]!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     appdeleget()
        
       
    }
    //to save pic in list in app deleget
    func appdeleget(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.memes.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemwTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.ImageTable?.image = meme.memedImage
        

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "detailMemeViewController") as! MemeDetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailController.image = meme.memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    @IBAction func newMeme(_ sender: Any) {
        
        let newMemes = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController!.pushViewController(newMemes, animated: true)
    }
    
}
