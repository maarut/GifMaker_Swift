//
//  UIViewController+Extensions.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 08/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//
import Foundation
import UIKit
import MobileCoreServices

// Regift Constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0

extension UIViewController: UINavigationControllerDelegate
{
    @IBAction func launchVideoCamera(sender: AnyObject)
    {
        let videoController = UIImagePickerController()
        videoController.sourceType = .Camera
        videoController.mediaTypes = [kUTTypeMovie as String]
        videoController.delegate = self
        presentViewController(videoController, animated: true, completion: nil)
    }
}

extension UIViewController: UIImagePickerControllerDelegate
{

    public func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let mediaType = info[UIImagePickerControllerMediaType] as? String
            where mediaType == (kUTTypeMovie as String),
            let rawVideoURL = info[UIImagePickerControllerMediaURL] as? NSURL {/*,
            let start = info["_UIImagePickerControllerVideoEditingStart"] as? Float,
            let duration = info["_UIImagePickerControllerVideoEditingDuration"] as? Float
        {
            cropVideoToSquare(rawVideoURL, start: start, duration: duration)
        }*/
            dismissViewControllerAnimated(true, completion: nil)
            convertVideoToGIF(rawVideoURL)
        }
    }
    
    func convertVideoToGIF(videoURL: NSURL)
    {
        let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif()
        let gif = Gif(pathToGif: gifURL!, pathToVideo: videoURL, caption: nil)
        displayGIF(gif)
    }
    
    func displayGIF(gif: Gif)
    {
        let gifEditorVC = storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController")
            as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }
}
