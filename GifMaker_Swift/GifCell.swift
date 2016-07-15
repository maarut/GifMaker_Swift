//
//  GifCell.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 12/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell
{
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureForGif(gif: Gif)
    {
        gifImageView.image = gif.gifImage
    }
}
