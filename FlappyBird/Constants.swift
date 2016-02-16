//
//  Constants.swift
//  JumperCrab
//
//  Created by fingent on 11/11/15.
//  Copyright (c) 2015 Fullstack.io. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit



// Sounds
let kSoundBounce = "bounce.caf"
let kSoundPop = "pop.caf"
let kSoundWhack = "whack.caf"
let kSoundFly = "flapping.caf"
let kSoundFalling = "falling.caf"
let kSoundHitGround = "hitGround.caf"
let kSoundScore = "coin.caf"
let kGameStartMusic = "caustic_chip.mp3"



let GameSoundsSharedInstance = GameSounds()

class GameSounds {

    class var sharedInstance:GameSounds {
        return GameSoundsSharedInstance
    }

    var sounds = [SKAction]()
    let bounce = SKAction.playSoundFileNamed(kSoundBounce, waitForCompletion: false)
    let score = SKAction.playSoundFileNamed(kSoundScore, waitForCompletion: false)
    let falling = SKAction.playSoundFileNamed(kSoundFalling, waitForCompletion: false)
    let flying = SKAction.playSoundFileNamed(kSoundFly, waitForCompletion: false)
    let hitGround = SKAction.playSoundFileNamed(kSoundHitGround, waitForCompletion: false)
    let pop = SKAction.playSoundFileNamed(kSoundPop, waitForCompletion: false)
    let whack = SKAction.playSoundFileNamed(kSoundWhack, waitForCompletion: false)
    let startMuscic = SKAction.playSoundFileNamed(kGameStartMusic, waitForCompletion: false)

    init() {
        sounds = [bounce, score, falling, flying, hitGround, pop, whack,startMuscic]
    }
}