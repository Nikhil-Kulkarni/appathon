//
//  ReservationViewController.swift
//  Hyped
//
//  Created by Nikhil Kulkarni on 4/17/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit
import Security

class ReservationViewController: UIViewController {
    
    var URL:NSString!
    var cookies:NSString!
    var dateInMilliseconds:NSString!
    var minutesDelay:NSString!
    var parsedObject:AnyObject!

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
        var indicator = UIActivityIndicatorView();
        indicator.frame = CGRectMake(0, 0, 40, 40)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator.startAnimating()
        
        let url = NSURL(string: "http://culcreserve.herokuapp.com/find")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        cookies = cookies.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
        
        request.HTTPBody = "{\n  \"cookies\": \"\(cookies)\",\n  \"breakoutRoomUrl\": \"\(self.URL)\", \n \"start\": \"\(self.dateInMilliseconds)\", \n  \"minutes\": \"\(self.minutesDelay)\"}".dataUsingEncoding(NSUTF8StringEncoding)
    
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            var parseError: NSError?
            self.parsedObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            println(self.parsedObject)
//            println(response)
//            println(data)
            
        
        if let toplevel = self.parsedObject as? NSDictionary {
            if let error: AnyObject = toplevel["error"] {
                println("ERROR")
                indicator.stopAnimating()
            }
            if let reservation: AnyObject = toplevel["reservations"] {
                if let cap: AnyObject? = reservation["capacity"] {
                    self.performSegueWithIdentifier("viewList", sender: nil)
                }
            }
            var alertController = UIAlertController(title: "Sorry!", message: "There are no rooms available for this time", preferredStyle: UIAlertControllerStyle.Alert)
            var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(animated: Bool) {
        var picker:UIDatePicker = UIDatePicker()
        picker.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        picker.datePickerMode = UIDatePickerMode.DateAndTime
        picker.minuteInterval = 15
        picker.addTarget(self, action: Selector("timeChange:"), forControlEvents: UIControlEvents.ValueChanged)
        picker.frame = CGRectMake(9, 199, 359, 162)
        self.view.addSubview(picker)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(URL)
        println(cookies)
        
    }
    
    func timeChange(datePicker:UIDatePicker) {
        dateInMilliseconds = (Int(datePicker.date.timeIntervalSince1970*1000)).description
//        println((datePicker.date.timeIntervalSinceReferenceDate*1000).description)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewList" {
            var controller = segue.destinationViewController as! UINavigationController
            var destination = controller.viewControllers[0] as! RoomTableTableViewController
            destination.parsedObject = self.parsedObject
            destination.cookies = self.cookies
        }
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
