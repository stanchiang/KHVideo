//
//  AddTiltViewController.swift
//  KHVideo
//
//  Created by sugar on 27/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit
import AVFoundation

class AddTiltViewController: CommonVideoViewController {

    
    
    @IBOutlet weak var tiltSegment: UISegmentedControl!
    
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
        // 1 - Layer setup
        var videoLayer = CALayer()
        var parentLayer = CALayer()
        
        parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
        videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
        parentLayer.addSublayer(videoLayer)
        
        // 2 - Set up the transform
        var identityTransform: CATransform3D = CATransform3DIdentity
        
        // 3 - Pick the direction
        if tiltSegment.selectedSegmentIndex == 0 {
            identityTransform.m34 = 1.0 / 1000 // greater the denominator lesser will be the transformation
        } else if tiltSegment.selectedSegmentIndex == 1 {
            identityTransform.m34 = 1.0 / -1000 // lesser the denominator lesser will be the transformation
        }
        // 4 - Rotate
        videoLayer.transform = CATransform3DRotate(identityTransform, CGFloat(M_PI)/6.0, 1, 0, 0)
        
        // 5 - Composition
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
    }
    
}
