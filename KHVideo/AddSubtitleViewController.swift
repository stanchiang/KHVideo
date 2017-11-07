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

    @IBAction func didPressLoadAsset(_ sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func didPressGenerateOutput(_ sender: AnyObject) {
        self.videoOutput()
    }

    override func applyVideoEffectsToComposition(_ composition: AVMutableVideoComposition!, size: CGSize) {
        
        // 1 - Set up the text layer
        let subTitle1Text = CATextLayer()
        subTitle1Text.font = "Helvetica-Bold" as CFTypeRef
        subTitle1Text.frame = CGRect(x: 0, y: 0, width: size.width, height: 100)
        subTitle1Text.string = self.subTitle1.text
        subTitle1Text.alignmentMode = kCAAlignmentCenter
        subTitle1Text.foregroundColor = UIColor.white.cgColor
        
        // 2 - The usual overlay
        let overlayLayer = CALayer()
        overlayLayer.addSublayer(subTitle1Text)
        overlayLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        overlayLayer.masksToBounds = true
        
        
        // 3 - set up the parent layer
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    

}
