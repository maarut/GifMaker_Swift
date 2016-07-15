//
//  WelcomeViewController.swift
//  GifMaker_Swift
//
//  Created by Maarut Chandegra on 08/07/2016.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        let pocGif = UIImage.gifWithName("hotlineBling")
        gifImageView.image = pocGif
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "WelcomeViewSeen")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
