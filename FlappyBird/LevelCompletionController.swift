//
//  LevelCompletionController.swift
//  JumperCrab
//
//  Created by fingent on 10/11/15.
//  Copyright (c) 2015 Fullstack.io. All rights reserved.
//

import UIKit

class LevelCompletionController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var levelScoreTable: UITableView!

    var scoreListImageArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        scoreListImageArray += [UIImage(named: "greenpipe.png")!,UIImage(named: "photo.png")!,UIImage(named: "coin.png")!, UIImage(named: "crown.png")!,UIImage(named: "Gem.png")!,UIImage(named: "gun.png")!,UIImage(named: "trophyicon.png")!,]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return scoreListImageArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = levelScoreTable.dequeueReusableCellWithIdentifier("levelScoreCellID", forIndexPath: indexPath) as! LevelScoreCell
        cell.scoreItemImage.image = scoreListImageArray[indexPath.row]


        return cell
    }

    //Buttons on the view
    @IBAction func homeButtonClicked(sender: AnyObject) {

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewControllerWithIdentifier("gameViewControllerID") as! GameViewController
         self.dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(vc, animated: true, completion: nil)

    }
    @IBAction func nextLevelButtonClicked(sender: AnyObject) {


    }
    func getCurrentLevelScoreDetails (levelName:String, totalScrore:String){

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
