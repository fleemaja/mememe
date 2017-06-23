//
//  DetailViewController.swift
//  memeMe
//
//  Created by Drew Fleeman on 6/22/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = meme?.memedImage {
            memeImageView.image = image
        } else {
            memeImageView.image = nil
        }
    }

}
