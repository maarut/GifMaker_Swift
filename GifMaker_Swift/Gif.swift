//
//  Gif.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 08/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding
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
        super.init()
    }
    
    init(pathToGif: NSURL, pathToVideo: NSURL, caption: String?)
    {
        self.pathToGIF = pathToGif
        self.caption = caption
        self.pathToVideo = pathToVideo
        if let gif = UIImage.gifWithURL(pathToGif.absoluteString) {
            self.gifImage = gif
        }
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(pathToGIF, forKey: "pathToGIF")
        aCoder.encodeObject(pathToVideo, forKey: "pathToVideo")
        aCoder.encodeObject(gifData, forKey: "gifData")
        aCoder.encodeObject(gifImage, forKey: "gifImage")
        aCoder.encodeObject(caption, forKey: "caption")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        pathToGIF = aDecoder.decodeObjectForKey("pathToGIF") as? NSURL
        caption = aDecoder.decodeObjectForKey("caption") as? String
        gifImage = aDecoder.decodeObjectForKey("gifImage") as? UIImage
        pathToVideo = aDecoder.decodeObjectForKey("pathToVideo") as? NSURL
        gifData = aDecoder.decodeObjectForKey("gifData") as? NSData
        
        super.init()
    }
}
