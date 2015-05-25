//
//  VideoPlayerViewController.swift
//  KHVideo
//
//  Created by sugar on 24/5/15.
//  Copyright (c) 2015 Konstantinos Hondros. All rights reserved.
//

import UIKit

class VideoPlayerViewController: CommonVideoViewController {
    
    
    @IBAction func didPressLoadAsset(sender: AnyObject) {
        self.startMediaBrowserFromViewController(self, usingDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
