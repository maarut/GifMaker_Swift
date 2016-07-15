//
//  DetailViewController.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 12/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
    var gif: Gif?
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        shareButton.layer.cornerRadius = 4.0
        
        if let gif = gif {
            imageView.image = gif.gifImage
        }
    }
    
    @IBAction func share(sender: AnyObject)
    {
        if let gifData = gif?.gifData {
            let shareController = UIActivityViewController(activityItems: [gifData], applicationActivities: nil)
            shareController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                if completed { self.dismissViewControllerAnimated(true, completion: nil) }
            }
            presentViewController(shareController, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismiss(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
