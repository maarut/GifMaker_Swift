//
//  SavedGifsViewController.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 12/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController
{
    var gifs = [Gif]()
    
    @IBOutlet weak var emptyCollectionPlaceholderView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        emptyCollectionPlaceholderView.hidden = gifs.count != 0
        collectionView.reloadData()
    }
}

extension SavedGifsViewController: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return gifs.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GifCell", forIndexPath: indexPath)
        if let cell = cell as? GifCell {
            cell.configureForGif(gifs[indexPath.row])
        }
        return cell
    }
}

extension SavedGifsViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if let nextVC = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController")
            as? DetailViewController {
            nextVC.gif = gifs[indexPath.row]
            nextVC.modalPresentationStyle = .OverCurrentContext
            presentViewController(nextVC, animated: true, completion: nil)
        }
    }
}

extension SavedGifsViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let width = (collectionView.frame.size.width - 24.0) / 2.0
        return CGSizeMake(width, width)
    }
}

extension SavedGifsViewController: PreviewViewControllerDelegate
{
    func previewViewController(controller: PreviewViewController, didSaveGif gif: Gif)
    {
        if let url = gif.pathToGIF {
            gif.gifData = NSData(contentsOfURL: url)
            gifs.append(gif)
        }
    }
}