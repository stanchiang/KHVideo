//
//  AddSubtitleViewController.swift
//  KHVideo
//
//  Created by sugar on 25/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit
import AVFoundation

class AddSubtitleViewController: CommonVideoViewController {
    
    @IBOutlet weak var subTitle1: UITextField!
    
    
    @IBAction func didPressLoadAsset(sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func didPressGenerateOutput(sender: AnyObject) {
        self.videoOutput()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Starting timer right now

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func applyVideoEffectsToComposition(composition: AVMutableVideoComposition!, size: CGSize) {
        
        // 1 - Set up the text layer
        var subTitle1Text = CATextLayer()
        subTitle1Text.font = "Helvetica-Bold"
        subTitle1Text.frame = CGRectMake(0, 0, size.width, 100)
        subTitle1Text.string = self.subTitle1.text
        subTitle1Text.alignmentMode = kCAAlignmentCenter
        subTitle1Text.foregroundColor = UIColor.whiteColor().CGColor
        
        // 2 - The usual overlay
        var overlayLayer = CALayer()
        overlayLayer.addSublayer(subTitle1Text)
        overlayLayer.frame = CGRectMake(0, 0, size.width, size.height)
        overlayLayer.masksToBounds = true
        
        
        // 3 - set up the parent layer
        var parentLayer = CALayer()
        var videoLayer = CALayer()
        parentLayer.frame = CGRectMake(0, 0, size.width, size.height)
        videoLayer.frame = CGRectMake(0, 0, size.width, size.height)
        
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
    }
    

}
