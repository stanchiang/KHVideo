//
//  AddBorderViewController.swift
//  KHVideo
//
//  Created by sugar on 27/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit
import AVFoundation

class AddBorderViewController: CommonVideoViewController {
    
    
    @IBOutlet weak var myview: UIView!
    @IBOutlet weak var widthBar: UISlider!
    @IBOutlet weak var colorSegment: UISegmentedControl!
    
    @IBAction func didPressLoadAsset(sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func didPressGenerateOutput(sender: AnyObject) {
        self.videoOutput()
    }
    
    func imageWithColor(color:UIColor, imageSize:CGRect) -> UIImage {
        var rect: CGRect = imageSize
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        widthBar.minimumValue = 1.0
        widthBar.maximumValue = 20.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func applyVideoEffectsToComposition(composition: AVMutableVideoComposition!, size: CGSize) {
        var borderImage: UIImage!
        
        if colorSegment.selectedSegmentIndex == 0 {
            borderImage = self.imageWithColor(UIColor.blueColor(), imageSize: CGRectMake(0, 0, size.width, size.height))
        } else if colorSegment.selectedSegmentIndex == 1 {
            borderImage = self.imageWithColor(UIColor.redColor(), imageSize: CGRectMake(0, 0, size.width, size.height))
        } else if colorSegment.selectedSegmentIndex == 2 {
            borderImage = self.imageWithColor(UIColor.greenColor(), imageSize: CGRectMake(0, 0, size.width, size.height))
        } else if colorSegment.selectedSegmentIndex == 3 {
            borderImage = self.imageWithColor(UIColor.whiteColor(), imageSize: CGRectMake(0, 0, size.width, size.height))
        }
        
        
        var backgroundLayer = CALayer()
        backgroundLayer.contents = borderImage.CGImage
        backgroundLayer.frame = CGRectMake(0, 0, size.width, size.height)
        backgroundLayer.masksToBounds = true
        
        var videoLayer = CALayer()
        let wval: Float = floor(widthBar.value)
        
        videoLayer.frame = CGRectMake(CGFloat(wval), CGFloat(wval), CGFloat(size.width) - CGFloat(wval * 2), CGFloat(size.height) - CGFloat( wval * 2))
        myview.layer.contents = borderImage.CGImage
        
        var parentLayer = CALayer()
        parentLayer.addSublayer(backgroundLayer)
        parentLayer.addSublayer(videoLayer)
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
