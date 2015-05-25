//
//  CommonVideoViewController.swift
//  KHVideo
//
//  Created by sugar on 24/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import AVFoundation

class CommonVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var videoAsset: AVAsset!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startMediaBrowserFromViewController(controller: UIViewController!, usingDelegate delegate: AnyObject) -> Bool {
        // 1 - Validations
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum).boolValue == false || controller == nil {
            return false
        }
        
        // 2 - Get image picker
        var mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie!]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate as? protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
        
        
        // 3 - Display image picker
        controller.presentViewController(mediaUI, animated: true, completion: nil)
        
        return true
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // 1 - Get media type
        //var mediaType: String = info[UIImagePickerControllerMediaMetadata]
        var mediaType = info[UIImagePickerControllerMediaType] as! String

        // 2 - Dismiss image picker
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // 3 - Handle video selection
        let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.CompareCaseInsensitive)
        if compareResult == CFComparisonResult.CompareEqualTo {
            //let assetUrl = NSURL(string: )
            
            self.videoAsset = AVAsset.assetWithURL(info[UIImagePickerControllerMediaURL] as! NSURL) as! AVAsset
            let alert = UIAlertView(title: "Asset Loaded", message:  "Video Asset Loaded", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func applyVideoEffectsToComposition(composition: AVMutableVideoComposition!, size: CGSize) {
        // no-op - override this method in the subclass
    }
    
    
    func videoOutput() {
        // 1 - Early exit if there's no video file selected
        if !(self.videoAsset != nil) {
            UIAlertView(title: "Error", message:  "Please Load a Video Asset First", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        var mixComposition = AVMutableComposition()
        
        // 3 - Video track
        let videoTrack: AVMutableCompositionTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration), ofTrack: self.videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack, atTime: kCMTimeZero, error: nil)
        
        // 3.1 - Create AVMutableVideoCompositionInstruction
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
        
        
        // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
        let videoLayerIntruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
    
        let videoAssetTrack: AVAssetTrack = self.videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack
        
        var videoAssetOrientation_: UIImageOrientation = .Up
        var isVideoAssetPortrait_: Bool = false
        
        let videoTransform:CGAffineTransform = videoAssetTrack.preferredTransform
        
        if videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0 {
            videoAssetOrientation_ = .Right
            isVideoAssetPortrait_ = true
        }
        if videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0 {
            videoAssetOrientation_ = .Left
            isVideoAssetPortrait_ = true
        }
        if videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0 {
            videoAssetOrientation_ = .Up
        }
        if videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0 {
            videoAssetOrientation_ = .Down
        }

        videoLayerIntruction.setTransform(videoAssetTrack.preferredTransform, atTime: kCMTimeZero)
        videoLayerIntruction.setOpacity(0.0, atTime: self.videoAsset.duration)
        
        
        // 3.3 - Add instructions
        mainInstruction.layerInstructions = [videoLayerIntruction!]
        
        let mainCompositionInst = AVMutableVideoComposition()
        
        var naturalSize = CGSize()
        
        if isVideoAssetPortrait_ {
            naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width)
        } else {
            naturalSize = videoAssetTrack.naturalSize
        }
        
        var renderWidth, renderHeight: CGFloat
        
        renderWidth = naturalSize.width
        renderHeight = naturalSize.height
        
        mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight)
        mainCompositionInst.instructions = [mainInstruction]
        mainCompositionInst.frameDuration = CMTimeMake(1, 30)
        
        self.applyVideoEffectsToComposition(mainCompositionInst, size: naturalSize)
        
        
        // 4 - Get path
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        var documentsDirectory = paths[0] as! NSString
        var myPathDocs = documentsDirectory.stringByAppendingPathComponent(String().stringByAppendingFormat("FinalVideo-%d.mov", arc4random() % 1000))
        let url = NSURL(fileURLWithPath: myPathDocs)
        
        // 5 - Create exporter
        var exporter: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exporter.outputURL = url
        exporter.outputFileType = AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse = true
        
        exporter.videoComposition = mainCompositionInst
        
        exporter.exportAsynchronouslyWithCompletionHandler({
            dispatch_async(dispatch_get_main_queue(),{
                self.exportDidFinish(exporter)
            })
        })
        
    }
    
    
    
    
    func exportDidFinish(session: AVAssetExportSession!) {
        if session.status == AVAssetExportSessionStatus.Completed {
            let outputURL = session.outputURL
            var library = ALAssetsLibrary()
            
            if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL) {
                
                library.writeVideoAtPathToSavedPhotosAlbum(outputURL, completionBlock:{ (assetURL: NSURL!, error: NSError!) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if (error != nil) {
                            UIAlertView(title: "Error", message:  "Video Saving Failed", delegate: nil, cancelButtonTitle: "OK").show()
                        } else {
                            UIAlertView(title: "Video Saved", message:  "Saved To Photo Album", delegate: nil, cancelButtonTitle: "OK").show()
                        }
                    })
                })
            }
        }
    }
    
     
}
