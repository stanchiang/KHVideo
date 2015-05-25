//
//  AddOverlayViewController.swift
//  KHVideo
//
//  Created by sugar on 24/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit
import AVFoundation


class AddOverlayViewController: CommonVideoViewController {
    
    
    @IBOutlet weak var frameSelectSegment: UISegmentedControl!
    
    @IBAction func loadAssetDidPress(sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func generateOutputDidPress(sender: AnyObject) {
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
        // 1 - set up the overlay
        var overlayLayer = CALayer()
        var overlayImage: UIImage!
        
        switch frameSelectSegment.selectedSegmentIndex
        {
        case 0:
            overlayImage = UIImage(named: "Frame-1.png")
        case 1:
            overlayImage = UIImage(named: "Frame-2.png")
        case 2:
            overlayImage = UIImage(named: "Frame-3.png")
        default:
            overlayImage = UIImage(named: "Frame-1.png")
        }
        

        overlayLayer.contents = overlayImage?.CGImage
        overlayLayer.frame = CGRectMake(0, 0, size.width, size.height)
        
        overlayLayer.masksToBounds = true
        
        
        // 2 - set up the parent layer
        var parentLayer = CALayer()
        var videoLayer = CALayer()
        
        parentLayer.frame = CGRectMake(0, 0, size.width, size.height)
        videoLayer.frame = CGRectMake(0, 0, size.width, size.height)
        
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        
        // 3 - apply magic
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        

        
    }
    
    
    
}
