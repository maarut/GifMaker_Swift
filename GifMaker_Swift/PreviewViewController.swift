//
//  PreviewViewController.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 08/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: AnyObject
{
    func previewViewController(controller: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController
{
    @IBOutlet weak var gifImageView: UIImageView!
    var gif: Gif?
    weak var delegate: PreviewViewControllerDelegate?
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if let gif = gif {
            gifImageView.image = gif.gifImage
        }
    }
    
    @IBAction func shareGif(sender: AnyObject)
    {
        if let pathToGif = gif?.pathToGIF,
            let gifData = NSData(contentsOfURL: pathToGif) {
            let shareController = UIActivityViewController(activityItems: [gifData],
                applicationActivities: nil)
            shareController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                if completed {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            presentViewController(shareController, animated: true, completion: nil)
        }
    }
    
    @IBAction func createAndSave(sender: AnyObject)
    {
        if let gif = gif {
            delegate?.previewViewController(self, didSaveGif: gif)
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
