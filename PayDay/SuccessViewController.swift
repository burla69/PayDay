//
//  SuccessViewController.swift
//  PayDay
//
//  Created by Oleksandr Burla on 3/17/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
    
    var JSONFromClock = [String: AnyObject]()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var name = ""
    var statusSuccess = ""
    var date = ""
    var time = ""
    var ampmText = ""
    var location = ""
    
    var isSuperUser = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(JSONFromClock)
        
        updateDataFrom(JSONFromClock)
        
        self.nameLabel.text = "Hi, \(name)"
        self.dateLabel.text = date
        self.timeLabel.text = time
        
        var statusText = "NO STATUS"
        
        if statusSuccess == "CLOCK IN" {
            statusText = "CLOCKED IN"
            self.statusLabel.textColor = UIColor(red:0.00, green:0.62, blue:0.23, alpha:1.0)

        } else if statusSuccess == "CLOCK OUT" {
            statusText = "CLOCKED OUT"
            self.statusLabel.textColor = UIColor(red:0.78, green:0.14, blue:0.14, alpha:1.0)
            
        } else if statusSuccess == "START BREAK" {
            statusText = "BREAKED IN"
            self.statusLabel.textColor = UIColor(red:0.98, green:0.75, blue:0.00, alpha:1.0)
            
        } else if statusSuccess == "STOP BREAK" {
            statusText = "BREAKED OUT"
            self.statusLabel.textColor = UIColor(red:0.78, green:0.14, blue:0.14, alpha:1.0)
            
        } else if statusSuccess == "DUTY IN" {
            statusText = "DUTY IN"
            self.statusLabel.textColor = UIColor(red:0.00, green:0.62, blue:0.23, alpha:1.0)
            
        } else if statusSuccess == "DUTY OUT" {
            statusText = "DUTY OUT"
            self.statusLabel.textColor = UIColor(red:0.78, green:0.14, blue:0.14, alpha:1.0)
            
        }
        
        self.statusLabel.text = statusText
        
        self.locationLabel.text = location

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateDataFrom(json: [String : AnyObject]) {
        
        self.location = (json["location"] as? String)!
        let timeText = (json["time"] as? NSString)!
        self.ampmText = timeText.substringFromIndex(timeText.length - 2)
        self.time = timeText.substringToIndex(timeText.length - 2)
        self.date = (json["date"] as? String)!
        
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        
        backAction()
    }
    @IBAction func okButtonPressed(sender: UIButton) {
        
        backAction()
    }
    
    func backAction() {
        print("SUPERUSER \(isSuperUser)")
        
        if isSuperUser == 1 {
            self.performSegueWithIdentifier("unwindToKeypadID", sender: nil)
        } else {
            self.performSegueWithIdentifier("unwindToLoginID", sender: nil)
            
        }
    }
    



}
