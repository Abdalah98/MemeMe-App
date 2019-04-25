//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Abdalah on 4/24/19.
//  Copyright © 2019 Abdalah. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imagedetail: UIImageView!
    var image: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imagedetail!.image = self.image
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    


}
