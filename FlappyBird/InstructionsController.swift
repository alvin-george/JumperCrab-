//
//  InstructionsController.swift
//  JumperCrab
//
//  Created by fingent on 04/11/15.
//  Copyright (c) 2015 Fullstack.io. All rights reserved.
//

import UIKit

class InstructionsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden =  false

        // Do any additional setup after loading the view.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        self.navigationController?.navigationBar.hidden =  false
        let orientation = Int(UIInterfaceOrientationMask.All.rawValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        return UIInterfaceOrientationMask.Landscape
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
