//
//  MemeTableViewCell.swift
//  memeMe
//
//  Created by Drew Fleeman on 6/22/17.
//  Copyright © 2017 drew. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!
    
    var meme: Meme? { didSet { updateUI() } }
    
    private func updateUI() {
        memeTextLabel?.text = "\(meme?.topText ?? "") \(meme?.bottomText ?? "")"
        
        if let image = meme?.memedImage {
            memeImageView.image = image
        } else {
            memeImageView.image = nil
        }
    }

}
