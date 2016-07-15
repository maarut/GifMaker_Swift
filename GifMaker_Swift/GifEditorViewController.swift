//
//  GifEditorViewController.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 08/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController
{
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var caption: UITextField!
    var gif: Gif?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        gifImageView.image = gif?.gifImage
        let defaultAttributes: [String: AnyObject] = [NSStrokeColorAttributeName: UIColor.blackColor(),
             NSStrokeWidthAttributeName: -4,
             NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40.0)!]
        caption.defaultTextAttributes = defaultAttributes
        caption.textAlignment = .Center
        caption.attributedPlaceholder = NSAttributedString(string: "Add Caption", attributes: defaultAttributes)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if let gif = gif {
            gifImageView.image = gif.gifImage
        }
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func presentPreview(sender: AnyObject)
    {
        let regift = Regift(sourceFileURL: self.gif!.pathToVideo!, frameCount: frameCount, delayTime: delayTime,
            loopCount: loopCount)
        let gifURL = regift.createGif(caption: caption.text, font: caption.font)
        let gif = Gif(pathToGif: gifURL!, pathToVideo: self.gif!.pathToVideo!, caption: caption.text)
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("PreviewViewController")
            as! PreviewViewController
        nextVC.gif = gif
        nextVC.delegate = navigationController?.viewControllers.last { $0 is PreviewViewControllerDelegate }
            as? PreviewViewControllerDelegate
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
}

// MARK: - UITextFieldDelegate Implementation
extension GifEditorViewController: UITextFieldDelegate
{
    func textFieldShouldEndEditing(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        textField.placeholder = nil
    }
}

// MARK: - Keyboard Notifications
extension GifEditorViewController
{
    private func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)),
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)),
            name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        if let userInfo = notification.userInfo,
            let keyboardFrameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return keyboardFrameEnd.CGRectValue().height
        }
        return 0.0
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func dismissKeyboard(gestureRecogniser: UITapGestureRecognizer)
    {
        caption.endEditing(true)
    }
}

private extension Array
{
    func last(@noescape comparator: Element -> Bool) -> Element?
    {
        for element in reverse() {
            if comparator(element) { return element }
        }
        return nil
    }
}