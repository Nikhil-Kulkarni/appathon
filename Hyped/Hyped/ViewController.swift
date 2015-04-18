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

