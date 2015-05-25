//
//  AddAnimationViewController.swift
//  KHVideo
//
//  Created by sugar on 25/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit
import AVFoundation

class AddAnimationViewController: CommonVideoViewController {
    
    
    @IBAction func didPressLoadAsset(sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func didPressGenerateOutput(sender: AnyObject) {
        self.videoOutput()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func applyVideoEffectsToComposition(composition: AVMutableVideoComposition!, size: CGSize) {
        
        
    }
    
    
}
