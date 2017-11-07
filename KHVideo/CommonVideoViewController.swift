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
    
    func startMediaBrowserFromViewController(_ controller: UIViewController!, usingDelegate delegate: AnyObject) {
        // 1 - Validations
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false || controller == nil {
            return
        }
        
        // 2 - Get image picker
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        
        // 3 - Display image picker
        controller.present(mediaUI, animated: true, completion: nil)
        
//        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 1 - Get media type
        //var mediaType: String = info[UIImagePickerControllerMediaMetadata]
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        // 2 - Dismiss image picker
        self.dismiss(animated: true, completion: nil)
        
        // 3 - Handle video selection
        let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.compareCaseInsensitive)
        if compareResult == CFComparisonResult.compareEqualTo {
            //let assetUrl = NSURL(string: )
            
            self.videoAsset = AVAsset(url: info[UIImagePickerControllerMediaURL] as! URL)
            let alert = UIAlertView(title: "Asset Loaded", message:  "Video Asset Loaded", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func applyVideoEffectsToComposition(_ composition: AVMutableVideoComposition!, size: CGSize) {
        // no-op - override this method in the subclass
    }
    
    
    func videoOutput() {
        // 1 - Early exit if there's no video file selected
        if !(self.videoAsset != nil) {
            UIAlertView(title: "Error", message:  "Please Load a Video Asset First", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        
        // 3 - Video track
        let videoTrack: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))!
        
        do {
            try videoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration), of: self.videoAsset.tracks(withMediaType: AVMediaType.video)[0], at: kCMTimeZero)
            
        } catch {
            print(error)
        }
        
        // 3.1 - Create AVMutableVideoCompositionInstruction
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.videoAsset.duration)
        
        
        // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
        let videoLayerIntruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
    
        let videoAssetTrack: AVAssetTrack = self.videoAsset.tracks(withMediaType: AVMediaType.video)[0] 
        
        var videoAssetOrientation_: UIImageOrientation = .up
        var isVideoAssetPortrait_: Bool = false
        
        let videoTransform:CGAffineTransform = videoAssetTrack.preferredTransform
        
        if videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0 {
            videoAssetOrientation_ = .right
            print("videoAssetOrientation_ = .right")
            isVideoAssetPortrait_ = true
        }
        if videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0 {
            videoAssetOrientation_ = .left
            print("videoAssetOrientation_ = .left")
            isVideoAssetPortrait_ = true
        }
        if videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0 {
            videoAssetOrientation_ = .up
            print("videoAssetOrientation_ = .up")
        }
        if videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0 {
            videoAssetOrientation_ = .down
            print("videoAssetOrientation_ = .down")
        }

        videoLayerIntruction.setTransform(videoAssetTrack.preferredTransform, at: kCMTimeZero)
        videoLayerIntruction.setOpacity(0.0, at: self.videoAsset.duration)
        
        
        // 3.3 - Add instructions
        mainInstruction.layerInstructions = [videoLayerIntruction]
        
        let mainCompositionInst = AVMutableVideoComposition()
        
        var naturalSize = CGSize()
        
        if isVideoAssetPortrait_ {
            naturalSize = CGSize(width: videoAssetTrack.naturalSize.height, height: videoAssetTrack.naturalSize.width)
            print("naturalSize1: \(naturalSize)")
        } else {
            naturalSize = videoAssetTrack.naturalSize
            print("naturalSize2: \(naturalSize)")
        }
        
        var renderWidth, renderHeight: CGFloat
        
        renderWidth = naturalSize.width
        renderHeight = naturalSize.height
        
        mainCompositionInst.renderSize = CGSize(width: renderWidth, height: renderHeight)
        mainCompositionInst.instructions = [mainInstruction]
        mainCompositionInst.frameDuration = CMTimeMake(1, 30)
        
        self.applyVideoEffectsToComposition(mainCompositionInst, size: naturalSize)
        
        
        // 4 - Get path
        let paths:NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        
        let documentsDirectory = paths[0] as! NSString
        let myPathDocs = documentsDirectory.appendingPathComponent(String().appendingFormat("FinalVideo-%d.mov", arc4random() % 1000))
        let url = URL(fileURLWithPath: myPathDocs)
        
        // 5 - Create exporter
        let exporter: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        
        exporter.videoComposition = mainCompositionInst
        
        exporter.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async(execute: {
                self.exportDidFinish(exporter)
            })
        })
        
    }
    
    
    
    
    func exportDidFinish(_ session: AVAssetExportSession!) {
        if session.status == AVAssetExportSessionStatus.completed {
            let outputURL = session.outputURL
            let library = ALAssetsLibrary()
            
            if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: outputURL) {                
                library.writeVideoAtPath(toSavedPhotosAlbum: outputURL, completionBlock: { (assetURL, error) in
                    DispatchQueue.main.async {
                        if error != nil {
                            UIAlertView(title: "Error", message:  "Video Saving Failed", delegate: nil, cancelButtonTitle: "OK").show()
                        } else {
                            UIAlertView(title: "Video Saved", message:  "Saved To Photo Album", delegate: nil, cancelButtonTitle: "OK").show()
                        }
                    }
                })
            }
        }
    }
    
     
}
