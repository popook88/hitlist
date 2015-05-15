//
//  DogHouseVC.swift
//  HitList
//
//  Created by Kevin Kane on 5/14/15.
//  Copyright (c) 2015 KevinKane. All rights reserved.
//

import UIKit
import AVFoundation

class DogHouseVC: UIViewController {
    
    var buttonBoop = AVAudioPlayer()
    var buttonTap = AVAudioPlayer()
    
    override func viewDidLoad() {
        title = "DogHouse"
        buttonBoop = self.setupAudioPlayerWithFile("boop", type:"wav")
    }

    @IBAction func partyFacePress(sender: UIButton) {
        buttonBoop.play()
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {

        var path = NSBundle.mainBundle().pathForResource(file as String, ofType:type as String)
        var url = NSURL.fileURLWithPath(path!)
        
        var error: NSError?
        
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)

        return audioPlayer!
    }
}
