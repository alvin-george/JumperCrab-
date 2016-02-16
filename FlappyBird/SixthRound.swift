//
//  SixthRound.swift
//  JumperCrab
//
//  Created by fingent on 03/11/15.
//  Copyright (c) 2015 Fullstack.io. All rights reserved.
//


import UIKit
import Foundation
import AVFoundation
import SpriteKit


class SixthRound: SKScene,SKPhysicsContactDelegate {


    //determines gap between pipes
    let verticalPipeGap = 210.0

    var bird:SKSpriteNode!
    var skyColor:SKColor!
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    var movePipesAndRemove:SKAction!
    var moving:SKNode!
    var pipes:SKNode!
    var canRestart = Bool()
    var scoreLabelNode:SKLabelNode!
    var score = NSInteger()

    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3

    var gameStatus:SKLabelNode!
    var levelGameAttemptDisplayCount = NSInteger()
    var levelGameAttemptCount = NSInteger()

    //Audio
    var audioPlayer1 = AVAudioPlayer()

    override func didMoveToView(view: SKView) {

        self.view?.makeToast(message: "Round 6")
        self.replayCurrentScene( "Round 6", currentGameSceneIndex: 5)
        self.levelGameAttemptDisplayCount = 1
        self.levelGameAttemptCount = 0

        canRestart = false
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -5.0 )
        self.physicsWorld.contactDelegate = self

        // setup background color
        skyColor = SKColor(red: 81.0/255.0, green: 192.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        self.backgroundColor = skyColor

        moving = SKNode()
        self.addChild(moving)
        pipes = SKNode()
        moving.addChild(pipes)

        // ground
        let groundTexture = SKTexture(imageNamed: "land6")
        groundTexture.filteringMode = .Nearest // shorter form for SKTextureFilteringMode.Nearest

        let moveGroundSprite = SKAction.moveByX(-groundTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.002 * groundTexture.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(groundTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))

        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( groundTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0)
            sprite.runAction(moveGroundSpritesForever)
            moving.addChild(sprite)
        }

        // skyline
        let skyTexture = SKTexture(imageNamed: "xmasbg")
        skyTexture.filteringMode = .Nearest

        let moveSkySprite = SKAction.moveByX(-skyTexture.size().width * 2.0, y: 0, duration: NSTimeInterval(0.1 * skyTexture.size().width * 2.0))
        let resetSkySprite = SKAction.moveByX(skyTexture.size().width * 2.0, y: 0, duration: 0.0)
        let moveSkySpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveSkySprite,resetSkySprite]))

        for var i:CGFloat = 0; i < 2.0 + self.frame.size.width / ( skyTexture.size().width * 2.0 ); ++i {
            let sprite = SKSpriteNode(texture: skyTexture)
            sprite.setScale(2.0)
            sprite.zPosition = -40
            sprite.position = CGPoint(x: i * sprite.size.width, y: sprite.size.height / 2.0 + groundTexture.size().height * 2.0)
            sprite.runAction(moveSkySpritesForever)
            moving.addChild(sprite)
        }

        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp6.png")
        pipeTextureUp.filteringMode = .Nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown6.png")
        pipeTextureDown.filteringMode = .Nearest

        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y:0.0, duration:NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])

        // spawn the pipes
        let spawn = SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)

        // setup our bird
        let birdTexture1 = SKTexture(imageNamed: "Crab6.png")
        birdTexture1.filteringMode = .Nearest

        let birdTexture2 = SKTexture(imageNamed: "Crab6.png")
        birdTexture2.filteringMode = .Nearest

        let anim = SKAction.animateWithTextures([birdTexture1, birdTexture2], timePerFrame: 0.2)
        let flap = SKAction.repeatActionForever(anim)

        bird = SKSpriteNode(texture: birdTexture1)
        bird.setScale(2.0)
        bird.position = CGPoint(x: self.frame.size.width * 0.35, y:self.frame.size.height * 0.6)
        bird.runAction(flap)


        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2.0)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false

        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.physicsBody?.contactTestBitMask = worldCategory | pipeCategory

        self.addChild(bird)

        // create the ground
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: groundTexture.size().height)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.frame.size.width, height: groundTexture.size().height * 2.0))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        self.addChild(ground)

        // Initialize label and create a label which holds the score
        score = 0
        scoreLabelNode = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        scoreLabelNode.position = CGPoint( x: self.frame.midX, y: self.frame.size.height/8 )
        scoreLabelNode.zPosition = 100
        scoreLabelNode.fontSize =  80
        scoreLabelNode.text = String(score)
        self.addChild(scoreLabelNode)

        //Initialize game status label
        gameStatus = SKLabelNode(fontNamed:"MarkerFelt-Wide")
        gameStatus.position = CGPoint( x: self.frame.midX, y: 3 * self.frame.size.height / 4 - 70 )
        gameStatus.zPosition = 100
        gameStatus.fontSize =  80
        self.addChild(gameStatus)

    }
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
        pipePair.zPosition = 0-10

        let height = UInt32( self.frame.size.height / 6)
        let y = Double(arc4random_uniform(height) + height);

        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)


        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size)
        pipeDown.physicsBody?.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)

        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x: 0.0, y: y)

        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody?.dynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)

        let contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeDown.size.width + bird.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.dynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)

        pipePair.runAction(movePipesAndRemove)
        pipes.addChild(pipePair)

    }
    func resetScene (){

        // Move bird to original position and reset velocity
        bird.position = CGPoint(x: self.frame.size.width / 2.5, y: self.frame.midY)
        bird.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        bird.physicsBody?.collisionBitMask = worldCategory | pipeCategory
        bird.speed = 1.0
        bird.zRotation = 0.0

        // Remove all existing pipes
        pipes.removeAllChildren()

        // Reset _canRestart
        canRestart = false

        // Reset score
        score = 0
        scoreLabelNode.text = "Score : "+String(score)

        // Restart animation
        moving.speed = 1
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if moving.speed > 0  {
            for touch: AnyObject in touches {
                gameStatus.text = ""

                let location = touch.locationInNode(self)

                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 55))
                self.audioPlayer1.playMusic("pop", audioFileType: "caf")

            }
        }
        else if canRestart {
            self.resetScene()
            self.view?.makeToast(message: "Crab's Attempt : "+String(self.levelGameAttemptDisplayCount) as String, duration: 0.3, position: HRToastPositionCenter)
            self.audioPlayer1.playMusic("pop", audioFileType: "caf")
        }
    }

    // TODO: Move to utilities somewhere. There's no reason this should be a member function
    func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
        if( value > max ) {
            return max
        } else if( value < min ) {
            return min
        } else {
            return value
        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        bird.zRotation = self.clamp( -1, max: 0.5, value: bird.physicsBody!.velocity.dy * ( bird.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )
    }

    func didBeginContact(contact: SKPhysicsContact) {
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Bird has contact with score entity
                score++
                scoreLabelNode.text =  "Score : "+String(score)
                self.audioPlayer1.playMusic("coin", audioFileType: "caf")

                // Add a little visual feedback for the score increment
                scoreLabelNode.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration:NSTimeInterval(0.1)), SKAction.scaleTo(1.0, duration:NSTimeInterval(0.1))]))
                //making transition to round One
                if (score == 15)
                {
                    self.removeActionForKey("flash")
                    self.runAction(SKAction.runBlock{
                        self.backgroundColor = SKColor(red: 0.3, green: 1, blue: 0.6, alpha: 1.0)
                        })

                    self.view?.makeToast(message: "Congratulations. You have completed The Sixth round. ")
                    //moving to level two
                    let gameStartScene = SeventhRound(size: self.frame.size)
                    gameStartScene.scaleMode = SKSceneScaleMode.AspectFill
                    let reveal = SKTransition.flipHorizontalWithDuration(2.0)
                    self.view?.presentScene(gameStartScene, transition: reveal)

                }
                else
                {

                }

            } else {

                moving.speed = 0
                self.audioPlayer1.playMusic("hitGround", audioFileType: "caf")

                bird.physicsBody?.collisionBitMask = worldCategory
                bird.runAction(  SKAction.rotateByAngle(CGFloat(M_PI) * CGFloat(bird.position.y) * 0.01, duration:1), completion:{self.bird.speed = 0 })

                //Increment AttemptCount
                self.levelGameAttemptDisplayCount++
                self.levelGameAttemptCount++

                // Flash background if contact is detected
                self.removeActionForKey("flash")
                self.runAction(SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.runBlock({
                    self.gameStatus.text = "Crab is Down"
                    self.audioPlayer1.playMusic("hitGround", audioFileType: "caf")

                }),SKAction.waitForDuration(NSTimeInterval(0.05)), SKAction.runBlock({
                    self.backgroundColor = self.skyColor
                }), SKAction.waitForDuration(NSTimeInterval(0.05))]), count:2), SKAction.runBlock({
                    if (self.levelGameAttemptCount == 3)
                    {
                        self.canRestart = false
                        self.audioPlayer1.playMusic("falling", audioFileType: "caf")

                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("gameOverControllerID") as! GameOverController
                        self.view!.window!.rootViewController!.dismissViewControllerAnimated(false, completion: nil)
                        UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(vc, animated: true, completion: nil)
                        //self.view!.window!.rootViewController!.performSegueWithIdentifier("gameOverSegue", sender: self)
                    }
                    else
                    {
                        self.canRestart = true
                        self.gameStatus.text = ""
                    }
                    
                })]), withKey: "flash")
            }
        }
    }
    
}
