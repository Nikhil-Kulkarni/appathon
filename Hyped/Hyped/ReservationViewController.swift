//
//  ReservationViewController.swift
//  Hyped
//
//  Created by Nikhil Kulkarni on 4/17/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {

    @IBOutlet weak var durationPicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        durationPicker.countDownDuration = NSTimeInterval(3)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindDate(segue: UIStoryboardSegue) {
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
