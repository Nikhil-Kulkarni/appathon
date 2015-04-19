//
//  ViewController.swift
//  Hyped
//
//  Created by Nikhil Kulkarni on 4/17/15.
//  Copyright (c) 2015 Nikhil Kulkarni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginView: UIButton!
    @IBOutlet weak var popoverView: UIView!
    
    @IBOutlet weak var backgroundimage: UIImageView!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var welcomeDescription: UILabel!
    
    @IBOutlet weak var reserve: UIButton!
    
    let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    var effect:UIVisualEffectView!
    var cookies:NSString!
    var url:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.reserve.layer.masksToBounds = false
        
        effect = UIVisualEffectView(effect: blurEffect)
        popoverView.transform = CGAffineTransformMakeTranslation(0, self.popoverView.frame.height * -1)
        
        var rect: CGRect = emailField.frame
        rect.size.height = 50
        emailField.frame = rect
        var passRect: CGRect = passwordField.frame
        passRect.size.height = 50
        passwordField.frame = passRect
        
        self.popoverView.layer.zPosition = 0
        
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        self.passwordField.endEditing(true)
        let url = NSURL(string: "http://culcreserve.herokuapp.com/login")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\n  \"user\": \"\(emailField.text)\",\n  \"pass\": \"\(passwordField.text)\"\n}".dataUsingEncoding(NSUTF8StringEncoding)
        
        var indicator = UIActivityIndicatorView();
        indicator.frame = CGRectMake(0, 0, 40, 40)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator.startAnimating()
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            var parseError: NSError?
            let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
//            println(parsedObject)
            
            if let toplevel = parsedObject as? NSDictionary {
                if let error: AnyObject = toplevel["error"] {
                    indicator.stopAnimating()
                    var alertController = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: UIAlertControllerStyle.Alert)
                    var action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    if let toplevel = parsedObject as? NSDictionary {
                        if let cookie: AnyObject = toplevel["cookies"] {
                            self.cookies = cookie as? NSString
                        }
                        if let requestSpaces: AnyObject = toplevel["requestSpaces"] {
                            if let breakRoomURL: AnyObject? = requestSpaces["Clough Breakout Rooms-INSTANT RESERVATION"] {
                                self.url = breakRoomURL as? NSString
                            }
                        }
                    }
                    indicator.stopAnimating()
                    self.performSegueWithIdentifier("reservations", sender: nil)
                }
            }
        }
        task.resume()
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: { () -> Void in
            self.effect.removeFromSuperview()
            self.popoverView.transform = CGAffineTransformMakeTranslation(0, self.popoverView.frame.height * -1 - 15)
            }, completion: nil)
        
        self.reserve.layer.shadowColor = UIColor.whiteColor().CGColor
        self.reserve.layer.shadowOpacity = 0
        self.reserve.layer.shadowRadius = 0
        self.reserve.layer.shadowOffset = CGSizeMake(0, 0)
        
        self.popoverView.layer.zPosition = 0
        self.backgroundimage.layer.zPosition = 1
        UIView.animateWithDuration(0.4, delay: 0.5, options: nil, animations: { () -> Void in
            self.emailField.endEditing(true)
            self.passwordField.endEditing(true)
            }, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "reservations") {
            var controller = segue.destinationViewController as! UINavigationController
            var destination = controller.viewControllers[0] as! ReservationViewController
            destination.URL = self.url
            destination.cookies = self.cookies
        }
    }
    
    
    @IBAction func reserveNow(sender: AnyObject) {
        effect.frame = self.view.frame
        
        self.reserve.layer.shadowColor = uicolorFromHex(0x2F36CE).CGColor
        self.reserve.layer.shadowOpacity = 0.8
        self.reserve.layer.shadowRadius = 2
        self.reserve.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        self.popoverView.layer.masksToBounds = false
        //        self.loginImageView.layer.cornerRadius = 8 // if you like rounded corners
        self.popoverView.layer.shadowOffset = CGSizeMake(0, 20)
        self.popoverView.layer.shadowRadius = 5
        self.popoverView.layer.shadowOpacity = 0.5
        self.popoverView.layer.zPosition = 1
        self.backgroundimage.layer.zPosition = 0
        
        emailField.becomeFirstResponder()
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: { () -> Void in
            self.reserve.addSubview(self.effect)
            self.welcomeDescription.addSubview(self.effect)
            self.welcomeText.addSubview(self.effect)
            self.backgroundimage.addSubview(self.effect)
            self.popoverView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
        
    }
    
    func uicolorFromHex(rgbValue:UInt32)-> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

