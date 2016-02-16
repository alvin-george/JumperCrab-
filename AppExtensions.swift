//
//  AppExtensions.swift
//  JumperCrab
//
//  Created by fingent on 04/11/15.
//  Copyright (c) 2015 Fullstack.io. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AVFoundation


//Audio
var audioPlayer = AVAudioPlayer()

extension AVAudioPlayer {

    func playMusic(audioFileName:String,audioFileType:String)
    {

        do {

        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioFileName, ofType: audioFileType)!)

       // Removed deprecated use of AVAudioSessionDelegate protocol
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        try audioPlayer = AVAudioPlayer(contentsOfURL: alertSound)
        audioPlayer.prepareToPlay()
        audioPlayer.play()

        }
        catch {
            print(error)
        }
}
}
