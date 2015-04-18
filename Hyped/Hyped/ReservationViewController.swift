//
//  ReservationViewController.swift
//  Hyped
//
//  Created by Nikhil Kulkarni on 4/17/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {
    
    var URL:NSString!
    var cookies:NSString!
    var dateInMilliseconds:NSString!
    var minutesDelay:NSString!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func delayChange(sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            minutesDelay = "30"
        case 1:
            minutesDelay = "60"
        case 2:
            minutesDelay = "90"
        case 3:
            minutesDelay = "120"
        default:
            minutesDelay = "60"
        }
        println(self.minutesDelay)
    }
    
    let welcome = UILabel(frame: CGRectMake(0, 78, 237, 38))
    
    @IBAction func findARoom(sender: AnyObject) {
        let url = NSURL(string: "http://culcreserve.herokuapp.com/find")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        cookies = cookies.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
        
        request.HTTPBody = "{\n  \"cookies\": \"\(cookies)\",\n  \"breakoutRoomUrl\": \"\(self.URL)\", \n \"start\": \"\(self.dateInMilliseconds)\", \n  \"minutes\": \"\(self.minutesDelay)\"}".dataUsingEncoding(NSUTF8StringEncoding)
        
        println("{\n  \"cookies\": \"\(cookies)\",\n  \"breakoutRoomURL\": \"\(self.URL)\", \n \"start\": \"\(self.dateInMilliseconds)\", \n  \"minutes\": \"\(self.minutesDelay)\"}")
    
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            var parseError: NSError?
            let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            println(parsedObject)
            println(response)
            println(data)
            
        
        if let toplevel = parsedObject as? NSDictionary {
            if let error: AnyObject = toplevel["error"] {
                println("ERROR")
            } else {
                
            }
                self.performSegueWithIdentifier("viewList", sender: nil)
            }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var picker:UIDatePicker = UIDatePicker()
        picker.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        picker.datePickerMode = UIDatePickerMode.DateAndTime
        picker.minuteInterval = 15
        picker.addTarget(self, action: Selector("timeChange:"), forControlEvents: UIControlEvents.ValueChanged)
        picker.frame = CGRectMake(9, 199, 359, 162)
        self.view.addSubview(picker)
        
        println(URL)
        println(cookies)
        
    }
    
    func timeChange(datePicker:UIDatePicker) {
        dateInMilliseconds = (Int(datePicker.date.timeIntervalSince1970*1000)).description
        println((datePicker.date.timeIntervalSinceReferenceDate*1000).description)
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
