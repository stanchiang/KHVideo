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
    
    
    @IBOutlet weak var animationSelectSegment: UISegmentedControl!
    
    @IBAction func didPressLoadAsset(_ sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func didPressGenerateOutput(_ sender: AnyObject) {
        self.videoOutput()
    }
    
    override func applyVideoEffectsToComposition(_ composition: AVMutableVideoComposition!, size: CGSize) {
        
        // 1
        let animationImage = UIImage(named: "star.png")
        
        let overlayLayer1 = CALayer()
        overlayLayer1.contents = animationImage?.cgImage
        overlayLayer1.frame = CGRect(x: size.width/2-64, y: size.height/2 + 200, width: 128, height: 128)
        overlayLayer1.masksToBounds = true
        
        let overlayLayer2 = CALayer()
        overlayLayer2.contents = animationImage?.cgImage
        overlayLayer2.frame = CGRect(x: size.width/2-64, y: size.height/2 - 200, width: 128, height: 128)
        overlayLayer2.masksToBounds = true
        
        // 2 - Rotate
        if animationSelectSegment.selectedSegmentIndex == 0 {
            
            var animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 2.0
            animation.repeatCount = 5
            animation.autoreverses = true
            // rotate from 0 to 360
            animation.fromValue = 0.0
            animation.toValue = 2.0 * Double.pi
            animation.beginTime = AVCoreAnimationBeginTimeAtZero
            overlayLayer1.add(animation, forKey: "rotation")
            
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 2.0
            animation.repeatCount = 5
            animation.autoreverses = true
            // rotate from 0 to 360
            animation.fromValue = 0.0
            animation.toValue = 2.0 * Double.pi
            animation.beginTime = AVCoreAnimationBeginTimeAtZero
            overlayLayer2.add(animation, forKey: "rotation")
            
            // 3 - Fade
        } else if animationSelectSegment.selectedSegmentIndex == 1 {
            
            var animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = 3.0
            animation.repeatCount = 5
            animation.autoreverses = true
            // animate from fully visible to invisible
            animation.fromValue = 1.0
            animation.toValue = 0.0
            animation.beginTime = AVCoreAnimationBeginTimeAtZero
            overlayLayer1.add(animation, forKey: "animatedOpacity")
            
            animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = 3.0
            animation.repeatCount = 5
            animation.autoreverses = true
            // animate from fully visible to invisible
            animation.fromValue = 1.0
            animation.toValue = 0.0
            animation.beginTime = AVCoreAnimationBeginTimeAtZero
            overlayLayer2.add(animation, forKey: "animatedOpacity")
            
            // 4 - Twinkle
        } else if animationSelectSegment.selectedSegmentIndex == 2 {
            
            var animation = CABasicAnimation(keyPath: "transform.scale")
            animation.duration = 0.5
            animation.repeatCount = 10
            animation.autoreverses = true
            // animate from half size to full size
            animation.fromValue = 0.5
            animation.toValue = 1.0
            animation.beginTime = AVCoreAnimationBeginTimeAtZero
            overlayLayer1.add(animation, forKey: "scale")
            
            animation = CABasicAnimation(keyPath: "transform.scale")
            animation.duration = 0.5
            animation.repeatCount = 10
            animation.autoreverses = true
            // animate from half size to full size
            animation.fromValue = 0.5
            animation.toValue = 1.0
            animation.beginTime = AVCoreAnimationBeginTimeAtZero
            overlayLayer2.add(animation, forKey: "scale")
        }
        
        //5
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer1)
        parentLayer.addSublayer(overlayLayer2)
        videoLayer.display()
        parentLayer.display()
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        videoLayer.display()
        parentLayer.display()
    }
    
    
}
