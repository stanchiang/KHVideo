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
    
    
    @IBOutlet weak var widthBar: UISlider!
    @IBOutlet weak var colorSegment: UISegmentedControl!
    
    @IBAction func didPressLoadAsset(_ sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    @IBAction func didPressGenerateOutput(_ sender: AnyObject) {
        self.videoOutput()
    }
    
    func imageWithColor(_ color:UIColor, imageSize:CGRect) -> UIImage {
        let rect: CGRect = imageSize
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func applyVideoEffectsToComposition(_ composition: AVMutableVideoComposition!, size: CGSize) {
        var borderImage: UIImage!
        
        if colorSegment.selectedSegmentIndex == 0 {
            borderImage = self.imageWithColor(UIColor.blue, imageSize: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        } else if colorSegment.selectedSegmentIndex == 1 {
            borderImage = self.imageWithColor(UIColor.red, imageSize: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        } else if colorSegment.selectedSegmentIndex == 2 {
            borderImage = self.imageWithColor(UIColor.green, imageSize: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        } else if colorSegment.selectedSegmentIndex == 3 {
            borderImage = self.imageWithColor(UIColor.white, imageSize: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        let backgroundLayer = CALayer()
        backgroundLayer.contents = borderImage.cgImage
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backgroundLayer.masksToBounds = true
        
        let videoLayer = CALayer()
        let wval: Float = floor(widthBar.value * 20)
        
        videoLayer.frame = CGRect(x: CGFloat(wval), y: CGFloat(wval), width: CGFloat(size.width) - CGFloat(wval * 2), height: CGFloat(size.height) - CGFloat( wval * 2))
        
        let parentLayer = CALayer()
        parentLayer.addSublayer(backgroundLayer)
        parentLayer.addSublayer(videoLayer)
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
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
