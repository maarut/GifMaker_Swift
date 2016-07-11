//
//  Gif.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 08/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif
{
    var pathToGIF: NSURL?
    var caption: String?
    var gifImage: UIImage?
    var pathToVideo: NSURL?
    var gifData: NSData?
    
    init(name: String)
    {
        if let gifImage = UIImage.gifWithName(name) {
            self.gifImage = gifImage
        }
        pathToGIF = NSURL()
        caption = ""
        pathToVideo = NSURL()
        gifData = NSData()
    }
    
    init(pathToGif: NSURL, pathToVideo: NSURL, caption: String?)
    {
        self.pathToGIF = pathToGif
        self.caption = caption
        self.pathToVideo = pathToVideo
        if let gif = UIImage.gifWithURL(pathToGif.absoluteString) {
            self.gifImage = gif
        }
        
    }
}
