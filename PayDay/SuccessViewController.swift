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
    @IBOutlet weak var locationLabel: UILabel!
    
    var name = ""
    var statusSuccess = ""
    var date = ""
    var time = ""
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
            statusText = "You have successfully CLOCKED IN at"

        } else if statusSuccess == "CLOCK OUT" {
            statusText = "You have successfully CLOCKED OUT at"
            
        } else if statusSuccess == "START BREAK" {
            statusText = "You have successfully BREAKED IN at"
            
        } else if statusSuccess == "STOP BREAK" {
            statusText = "You have successfully BREAKED OUT at"
            
        } else if statusSuccess == "DUTY IN" {
            statusText = "You have successfully DUTY IN at"
            
        } else if statusSuccess == "DUTY OUT" {
            statusText = "You have successfully DUTY OUT at"
            
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
        self.time = (json["time"] as? String)!
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
