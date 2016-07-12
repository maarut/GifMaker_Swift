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
import AVFoundation

// Regift Constants
let frameCount = 16
let frameRate = 15
let delayTime: Float = 0.2
let loopCount = 0

extension UIViewController: UINavigationControllerDelegate
{
    @IBAction func presentVideoOptions(sender: AnyObject)
    {
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
             launchPhotoLibrary()
            return
        }
        let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: .ActionSheet)
        let recordVideo = UIAlertAction(title: "Record a Video", style: .Default) { _ in
            self.launchVideoCamera()
        }
        let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .Default) { _ in
             self.launchPhotoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        newGifActionSheet.addAction(recordVideo)
        newGifActionSheet.addAction(chooseFromExisting)
        newGifActionSheet.addAction(cancel)
        newGifActionSheet.view.tintColor = UIColor(red: 1.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        
        presentViewController(newGifActionSheet, animated: true, completion: nil)
    }
    
    private func launchVideoCamera()
    {        presentViewController(pickerController(.Camera), animated: true, completion: nil)
    }
    
    private func launchPhotoLibrary()
    {
        presentViewController(pickerController(.PhotoLibrary), animated: true, completion: nil)
    }
    
    private func pickerController(source: UIImagePickerControllerSourceType) -> UIViewController
    {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.mediaTypes = [kUTTypeMovie as String]
        controller.allowsEditing = true
        controller.delegate = self
        return controller
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
            let rawVideoURL = info[UIImagePickerControllerMediaURL] as? NSURL
        {
            if let start = info["_UIImagePickerControllerVideoEditingStart"] as? Float,
                let end = info["_UIImagePickerControllerVideoEditingEnd"] as? Float {
                cropVideoToSquare(rawVideoURL, start: start, duration: end - start)
            }
            else {
                cropVideoToSquare(rawVideoURL)
            }
        }
    }
    
    private func cropVideoToSquare(videoURL: NSURL, start: Float = 0.0, duration: Float = -1.0)
    {
        let asset = AVAsset(URL: videoURL)
        if let videoTrack = asset.tracksWithMediaType(AVMediaTypeVideo).first {
            let videoComposition = AVMutableVideoComposition()
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height)
            videoComposition.frameDuration = CMTimeMake(1, 30)
            
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
            
            let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
            let t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height,
                -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) / 2.0 )
            let finalTransform = CGAffineTransformRotate(t1, CGFloat(M_PI_2))
            
            transformer.setTransform(finalTransform, atTime: kCMTimeZero)
            instruction.layerInstructions = [transformer]
            videoComposition.instructions = [instruction]
            
            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
            exporter.videoComposition = videoComposition
            exporter.outputURL = createPath()
            exporter.outputFileType = AVFileTypeQuickTimeMovie
            
            exporter.exportAsynchronouslyWithCompletionHandler {
                self.convertVideoToGIF(exporter.outputURL!, start: start, duration: duration)
            }
        }
    }
    
    private func createPath() -> NSURL
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        let fm = NSFileManager.defaultManager()
        let outputDir = NSURL(fileURLWithPath: documentsDirectory!).URLByAppendingPathComponent("output",
            isDirectory: true)
        do { try fm.createDirectoryAtURL(outputDir, withIntermediateDirectories: true, attributes: nil) }
        catch {}
        let outputFile = outputDir.URLByAppendingPathComponent("output.mov", isDirectory: false)
        do { try fm.removeItemAtURL(outputFile) }
        catch {}
        return outputFile
    }
    
    private func convertVideoToGIF(videoURL: NSURL, start: Float = 0.0, duration: Float = -1.0)
    {
        dispatch_async(dispatch_get_main_queue()) { self.dismissViewControllerAnimated(true, completion: nil) }
        let regift: Regift
        if duration < 0.0 {
            regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime,
                loopCount: loopCount)
        }
        else {
            regift = Regift(sourceFileURL: videoURL, startTime: start, duration: duration, frameRate: frameRate,
                loopCount: loopCount)
        }
        let gifURL = regift.createGif()
        let gif = Gif(pathToGif: gifURL!, pathToVideo: videoURL, caption: nil)
        displayGIF(gif)
    }
    
    private func displayGIF(gif: Gif)
    {
        let gifEditorVC = storyboard?.instantiateViewControllerWithIdentifier("GifEditorViewController")
            as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }
}
