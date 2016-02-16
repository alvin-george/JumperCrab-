//
//  GameOverController.swift
//  JumperCrab
//
//  Created by fingent on 09/11/15.
//  Copyright (c) 2015 Fullstack.io. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        let sceneData = try? NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")

        //Loading Game Scenes
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene

        archiver.finishDecoding()

        return scene
    }
}

class GameOverController: UIViewController{

    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var ReplayButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!

    //GAME LEVEL
    var gameLevelSceneNameArray = NSArray()
    var currentGameSceneAtVC:String?
    var currentGameSceneIndexAtVC:Int?

    //ScoreView
    var dynamicView = UIView()
    var roundNamelabel = UILabel()
    var scoreLabel = UILabel()

    var currentRoundNameString:String =  String()
    var currentScoreString:String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameLevelSceneNameArray = ["GameScene","SecondRound","ThirdRound", "FourthRound","FifthRound","SixthRound","SeventhRound", "EighthRound","NinethRound"]

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Main Button Methods on the View
    @IBAction func mainMenuButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("gameViewControllerID") as! GameViewController
//        self.presentViewController(vc, animated: true, completion: nil)

        var top =  UIViewController()
        top = UIApplication.sharedApplication().keyWindow!.rootViewController!
        top.presentViewController(vc, animated: true, completion: nil)

//        UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [top presentViewController:secondView animated:YES completion: nil];

    }
    @IBAction func replayButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        currentGameSceneIndexAtVC =   NSUserDefaults.standardUserDefaults().integerForKey("LevelInt")
        currentGameSceneAtVC = NSUserDefaults.standardUserDefaults().objectForKey("LevelName") as? String

        //self.moveToSelectedGameLevel(currentGameSceneAtVC!, gameSceneName: self.gameLevelSceneNameArray[currentGameSceneIndexAtVC!] as! String)

    }
    @IBAction func scoreButtonClicked(sender: AnyObject) {

        currentRoundNameString = (NSUserDefaults.standardUserDefaults().objectForKey("currentRoundName") as? String)!
        currentScoreString = (NSUserDefaults.standardUserDefaults().objectForKey("currentRoundScore") as? String)!

      dynamicView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+50, self.view.frame.size.width, self.view.frame.size.height-60 )
        dynamicView.backgroundColor = UIColor.grayColor()
        dynamicView.layer.cornerRadius = 25
        dynamicView.layer.borderWidth = 2
        self.view.addSubview(dynamicView)

        let imageName = "crab.launch.png"
        let image = UIImage(named: imageName)
        let scoreImageView = UIImageView(image: image!)

        scoreImageView.frame = CGRect(x: 10, y: 20, width: 160, height: 140)
        view.addSubview(scoreImageView)
        dynamicView.addSubview(scoreImageView)


        roundNamelabel.frame = CGRectMake(180, 30, 230, 40)
        roundNamelabel.textAlignment = NSTextAlignment.Center
        roundNamelabel.textColor = UIColor.whiteColor()
        roundNamelabel.text = currentRoundNameString
        roundNamelabel.font =  UIFont (name: "MarkerFelt-Wide", size: 30)
        dynamicView.addSubview(roundNamelabel)



        scoreLabel.frame = CGRectMake(180, 90, 230, 40)
        scoreLabel.textAlignment = NSTextAlignment.Center
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.text =  "Score   :   "+currentScoreString
        scoreLabel.font =  UIFont (name: "MarkerFelt-Wide", size: 30)
        dynamicView.addSubview(scoreLabel)

        let dynamicButton = UIButton(type: UIButtonType.System)
        dynamicButton.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        dynamicButton.frame = CGRectMake(dynamicView.frame.size.width-90, dynamicView.frame.size.height-100, 70, 70)
        dynamicButton.addTarget(self, action: "backButtonPressedOnScoreView", forControlEvents: UIControlEvents.TouchUpInside)
        dynamicView.addSubview(dynamicButton)
    }
    func backButtonPressedOnScoreView()
    {
        dynamicView.removeFromSuperview()

    }
    //Moving To Levels
    func moveToSelectedGameLevel(levelNameString:String, gameSceneName:String)
    {
         let skView = SKView(frame: self.view.frame)
        self.view.addSubview(skView)
        
        switch(levelNameString)
        {
        case "Round 1":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 2" :
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 3":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 4":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 5":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 6":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 7":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 8":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        case "Round 9":
            if let gameScene = SKScene.sceneWithClassNamed(gameSceneName, fileNamed: gameSceneName) {
                skView.presentScene(gameScene)
            }
        default:
            print("", terminator: "")
        }
    }
    func getScoreDisplayData(roundName:String, Score :String)
    {
        NSUserDefaults.standardUserDefaults().setObject(roundName, forKey: "currentRoundName")
        NSUserDefaults.standardUserDefaults().synchronize()

        NSUserDefaults.standardUserDefaults().setObject(Score, forKey: "currentRoundScore")
        NSUserDefaults.standardUserDefaults().synchronize()
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
