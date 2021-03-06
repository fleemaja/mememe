//
//  MemeCollectionViewCell.swift
//  memeMe
//
//  Created by Drew Fleeman on 6/20/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var meme: Meme? { didSet { updateUI() } }
    
    private func updateUI() {
        
        if let image = meme?.memedImage {
            memeImageView.image = image
        } else {
            memeImageView.image = nil
        }
    }
    
}
