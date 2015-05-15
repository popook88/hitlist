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
    
    var buttonBoops = [AVAudioPlayer()]
//    var buttonBoop = AVAudioPlayer()
    var buttonTap = AVAudioPlayer()
    
    override func viewDidLoad() {
        title = "DogHouse"
        initializeSound()
    }
    
    func initializeSound(){
        var buttonBoop = AVAudioPlayer()
        buttonBoop = setupAudioPlayerWithFile("boop", type: "wav")
        buttonBoops[0] = buttonBoop
    }

    @IBAction func partyFacePress(sender: UIButton) {
        
        for boop in buttonBoops{
            if boop.playing == false{
                boop.play()
                return
            }
        }
        appendAndPlayNewBoop()
    }
    
    func appendAndPlayNewBoop(){
        var buttonBoop = AVAudioPlayer()
        buttonBoop = setupAudioPlayerWithFile("boop", type: "wav")
        buttonBoops.append(buttonBoop)
        buttonBoops[buttonBoops.count-1].play()
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
