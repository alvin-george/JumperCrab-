//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nate Murray on 6/2/14.
//  Copyright (c) 2014 Fullstack.io. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
import AVFoundation

extension SKNode {
    class func unarchiveFromFileAndLoadGameScene(file : String) -> SKNode? {
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
extension SKScene {
    static func sceneWithClassNamed(className: String, fileNamed fileName: String) -> SKScene? {
        if let SceneClass = NSClassFromString("JumperCrab.\(className)") as? SKScene.Type,
            let scene = SceneClass.init(fileNamed: fileName) {
                return scene
        }
        return nil
    }
    func replayCurrentScene(currentLevelName: String,currentGameSceneIndex:Int)
    {
        //passing current game data
        GameViewController().getReplayCurrentSceneDetailsToVC(currentLevelName, currentGameSceneIndex: currentGameSceneIndex)
    }
}

class GameViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{

    //Storyboard Reference
    @IBOutlet weak var bgimage: UIImageView!
    @IBOutlet weak var titlleLabel: UILabel!
    @IBOutlet weak var crabimage: UIImageView!
    @IBOutlet weak var playnowButton: UIButton!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var quitgameButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var playAndPauseButton: UIButton!
    @IBOutlet weak var replaybutton: UIButton!

    //gameLevelListPicker
    var gameLevelListPicker = UIPickerView()
    var gameLevelPickerDataArray = NSArray()
    var actionView: UIView = UIView()
    var window: UIWindow? = nil
    var selectedFolderItem:AnyObject?
    var selectedGameSceneItem:AnyObject?

    //GAME LEVEL
    var gameLevelSceneNameArray = NSArray()
    var currentGameSceneAtVC:String?
    var currentGameSceneIndexAtVC:Int?

    //Audio
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainMenuButton.hidden =  true
        self.playAndPauseButton.hidden =  true
        self.replaybutton.hidden = true
        self.playAndPauseButton.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
        self.audioPlayer.playMusic("caustic_chip", audioFileType: "mp3")


        //Game Scenes
        gameLevelSceneNameArray = ["GameScene","SecondRound","ThirdRound", "FourthRound","FifthRound","SixthRound","SeventhRound", "EighthRound","NinethRound"]


        //Game Level ListPicker
        var delegate = UIApplication.sharedApplication()
        var myWindow:UIWindow? = delegate.keyWindow
        var myWindow2:NSArray = delegate.windows
        gameLevelPickerDataArray = ["Round 1","Round 2","Round 3","Round 4","Round 5","Round 6","Round 7","Round 8","Round 9"]
        if let myWindow: UIWindow = UIApplication.sharedApplication().keyWindow
        {
            window = myWindow
        }
        else
        {
            window = myWindow2[0] as? UIWindow
        }
        gameLevelListPicker.backgroundColor = UIColor.whiteColor()
        actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 200)
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation = Int(UIInterfaceOrientationMask.All.rawValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        return UIInterfaceOrientationMask.Landscape
    }
    //MARK:- GAME LEVEL PICKERVIEW DELEGATE METHODS
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gameLevelPickerDataArray.count
    }
    func numberOfComponentsInPickerView(_pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gameLevelPickerDataArray[row] as! String
    }
    //MARK:- GAME LEVEL PICKERVIEW BUTTON METHODS
    func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 210.0)
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    func folderSelectionDoneClicked(sender: UIBarButtonItem) {

        let myRow = gameLevelListPicker.selectedRowInComponent(0)
        selectedFolderItem =  gameLevelPickerDataArray[myRow] as! String
        selectedGameSceneItem =  gameLevelSceneNameArray[myRow] as! String

        //Moving to selected game level
        self.moveToSelectedGameLevel(selectedFolderItem as! String, gameSceneName: selectedGameSceneItem as! String)

        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 260.0)
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView
                    {
                        view.removeFromSuperview()
                    }
                }
        })
    }

    //MARK:- PLAY, INSTRUCTIONS AND QUIT
    @IBAction func palynowClicked(sender: AnyObject) {
        //   audioPlayer.stop()
        self.removeUIElement()
        self.mainMenuButton.hidden =  false
        self.playAndPauseButton.hidden =  false
        self.replaybutton.hidden = false

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    @IBAction func instructionClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("segueToInstructions", sender: self)
    }
    @IBAction func quitgameButtonClicked(sender: AnyObject) {
        audioPlayer.stop()
        if #available(iOS 8.0, *) {
            let refreshAlert = UIAlertController(title: "Quit Game", message: "The operation will exit the game from your iPhone. Do you wish to continue ? ", preferredStyle: UIAlertControllerStyle.Alert)

            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Destructive, handler: { (action: UIAlertAction) in
                exit(0)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
                refreshAlert .dismissViewControllerAnimated(true, completion: nil)
                self.audioPlayer.play()
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)

        } else {
            // Fallback on earlier versions
        }


    }
    //MARK:- MAIN MENU BUTTON DURING PLAY
    @IBAction func mainMenuButtonClicked(sender: AnyObject) {
        let skView = self.view as! SKView
        skView.scene!.paused = true
        self.showGameMenuWithOptions()
    }
    @IBAction func playAndPauseButtonClicked(sender: AnyObject) {
        let skView = self.view as! SKView
        skView.scene!.paused = true

        if (playAndPauseButton.currentImage == UIImage(named: "pause.png"))
        {
            playAndPauseButton.setImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
        }
        else
        {
            playAndPauseButton.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
            skView.scene!.paused = false
        }
    }
    @IBAction func replayButtonClicked(sender: AnyObject) {

        currentGameSceneIndexAtVC =   NSUserDefaults.standardUserDefaults().integerForKey("LevelInt")
        currentGameSceneAtVC = NSUserDefaults.standardUserDefaults().objectForKey("LevelName") as? String

        self.moveToSelectedGameLevel(currentGameSceneAtVC!, gameSceneName: self.gameLevelSceneNameArray[currentGameSceneIndexAtVC!] as! String)

    }
    //Game Menu - Main
    func showGameMenuWithOptions() {

        let skView = self.view as! SKView
        skView.scene!.paused = true

        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: "Game Menu", message: "Thanks for using Mr.Jumper Crab. What would you like to do now?", preferredStyle: UIAlertControllerStyle.Alert)

            alert.addAction(UIAlertAction(title: "Resume", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                let skView = self.view as! SKView
                skView.scene!.paused = false

            }))
            alert.addAction(UIAlertAction(title: "Start A New Game", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.moveToSelectedGameLevel("Round 1", gameSceneName: self.gameLevelSceneNameArray[0] as! String)

            }))
            alert.addAction(UIAlertAction(title: "Select Game Level", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.displayGameLevelSelectionPicker()
            }))

            alert.addAction(UIAlertAction(title: "Return To Home", style: UIAlertActionStyle.Destructive, handler: { alertAction in

                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewControllerWithIdentifier("gameViewControllerID") as! GameViewController

                dispatch_async(dispatch_get_main_queue(),{
                    // alert.dismissViewControllerAnimated(true, completion: nil)
                    self.dismissViewControllerAnimated(false, completion: nil)
                    self.view.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)
                })
            }))
            self.presentViewController(alert, animated: true, completion: nil)

        } else {
            // Fallback on earlier versions
        }
    }
    //MARK:- MAKING  GAME LEVEL SELECTION PICKER
    func displayGameLevelSelectionPicker()
    {
        //Making uploadFolderListPicker
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        gameLevelListPicker.frame = CGRectMake(0.0, 44.0,kSCREEN_WIDTH, 200.0)
        gameLevelListPicker.dataSource = self
        gameLevelListPicker.delegate = self
        gameLevelListPicker.showsSelectionIndicator = true;
        gameLevelListPicker.backgroundColor = UIColor.whiteColor()

        let folderPickerToolbar = UIToolbar(frame: CGRectMake(0, 0, kSCREEN_WIDTH, 44))
        folderPickerToolbar.barStyle = UIBarStyle.Black
        folderPickerToolbar.barTintColor = UIColor.blackColor()
        folderPickerToolbar.translucent = true

        let barItems = NSMutableArray()
        let cancelLabel = UILabel()
        cancelLabel.text = " Cancel"

        let cancelTitleLabel = UIBarButtonItem(title: cancelLabel.text, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelPickerSelectionButtonClicked:"))
        cancelTitleLabel.tintColor = UIColor.whiteColor()
        barItems.addObject(cancelTitleLabel)

        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        barItems.addObject(flexSpace)

        let folderListSelectedDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("folderSelectionDoneClicked:"))
        barItems.addObject(folderListSelectedDone)
        folderListSelectedDone.tintColor = UIColor.whiteColor()

        folderPickerToolbar.setItems(barItems as [AnyObject] as? [UIBarButtonItem], animated: true)
        actionView.addSubview(folderPickerToolbar)
        actionView.addSubview(gameLevelListPicker)

        if (window != nil) {
            window!.addSubview(actionView)
        }
        else {
            self.view.addSubview(actionView)
        }
        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 210.0, UIScreen.mainScreen().bounds.size.width, 210.0)
        })
    }
    func removeUIElement()
    {
        self.bgimage.removeFromSuperview()
        self.crabimage.removeFromSuperview()
        self.titlleLabel.removeFromSuperview()
        self.playnowButton.removeFromSuperview()
        self.instructionButton.removeFromSuperview()
        self.quitgameButton.removeFromSuperview()
    }
    func moveToSelectedGameLevel(levelNameString:String, gameSceneName:String)
    {
        let skView = self.view as! SKView
        skView.bounds =  self.view.bounds
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
    func getReplayCurrentSceneDetailsToVC(currentLevelName: String,currentGameSceneIndex:Int)
    {
        NSUserDefaults.standardUserDefaults().setInteger(currentGameSceneIndex, forKey: "LevelInt")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        NSUserDefaults.standardUserDefaults().setObject(currentLevelName, forKey: "LevelName")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
