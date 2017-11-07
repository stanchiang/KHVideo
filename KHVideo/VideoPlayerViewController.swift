//
//  VideoPlayerViewController.swift
//  KHVideo
//
//  Created by sugar on 24/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit

class VideoPlayerViewController: CommonVideoViewController {
    
    @IBAction func didPressLoadAsset(_ sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }

}
