//
//  KeypadViewController.swift
//  PayDay
//
//  Created by Oleksandr Burla on 3/15/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit

//add hello


class KeypadViewController: UIViewController, QRScanningViewControllerDelegate {
    
    var JSONFromLogin = [String: AnyObject]()
    var location = ""
    var token = ""
    var firstName = ""
    var lastName = ""
    var time = ""
    var date = ""
    var tmsIDtemp = ""
    var userOption = 0
    
    let baseURL = "http://ec2-52-34-242-50.us-west-2.compute.amazonaws.com"
    
    var isSuperUser = 0
    
    
    @IBOutlet weak var whiteView: UIView!

    @IBOutlet weak var keyPadButton1: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var myNavigationItem: UINavigationItem!
    
    @IBOutlet weak var TmsID: UITextField!
    
    @IBOutlet weak var ampmLabel: UILabel!
    
    var isFirstDigit = true

    
    @IBAction func numberButtonPressed(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        TmsID.text = isFirstDigit ? digit : TmsID.text! + digit
        isFirstDigit = false
        
    }
    
    @IBAction func deleteButtonPressed(sender: UIButton) {
        let tempString = TmsID.text
        TmsID.text = String(tempString!.characters.dropLast())
    }
    
    
    @IBAction func qrButtonPressed(sender: UIButton) {
        
        let vc: QRScanningViewController = self.storyboard?.instantiateViewControllerWithIdentifier("scanController") as! QRScanningViewController
        
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func okButton(sender: UIButton) {
        
        goFromQRCode()
        
    }
    
    
    func goFromQRCode() {
        let params = ["token": self.token, "user_identifier": TmsID.text!]
        
        self.postRequest("/api/v1/users/identify/", params: params)
 
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        showTime()
        NSTimer.scheduledTimerWithTimeInterval(59, target: self, selector: #selector(showTime), userInfo: nil, repeats: true)
        
        updateDataFrom(JSONFromLogin)
        
        self.locationLabel.text = location
        self.dateLabel.text = date
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //keyPadButton1.layoutSubviews()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    func showTime() {
        let date = NSDate()
        let outputFormat = NSDateFormatter()
        //outputFormat.locale = NSLocale(localeIdentifier:"en_US")
        outputFormat.dateFormat = "hh:mm"
        timeLabel.text = outputFormat.stringFromDate(date)
        
        outputFormat.dateFormat = "a"
        ampmLabel.text = outputFormat.stringFromDate(date)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateDataFrom(json: [String : AnyObject]) {
        
        self.location = (json["location"] as? String)!
        self.token = (json["token"] as? String)!
        self.time = (json["time"] as? String)!
        self.date = (json["date"] as? String)!
        
    }
    

    @IBAction func unwindToKeypad(segue: UIStoryboardSegue) {
        self.TmsID.text = ""
    }
    

    
    func qrCodeFromQRViewController(string: String) {
        
        tmsIDtemp = string
        self.TmsID.text = self.tmsIDtemp
        
    }
    
    //MARK: POST func
    
    func postRequest(path: String, params: [String: AnyObject]) {
        
        let fullURL = "\(baseURL)\(path)"
        
        let request = NSMutableURLRequest(URL: NSURL(string: fullURL)!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // or if you think the conversion might actually fail (which is unlikely if you built `params` yourself)
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch {
            print(error)
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Authentication error", message: "Can not load data from web. Please check your Internet conection and try again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    
                    alert.addAction(cancel)
                    
                    self.presentViewController(alert, animated: false, completion: nil)
                })

                
                
                return
            }
            
            // this, on the other hand, can quite easily fail if there's a server error, so you definitely
            // want to wrap this in `do`-`try`-`catch`:
            
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                                        
                    if let success = json["status"] as? Int {
                        print(success)
                        //print(json)
                        dispatch_async(dispatch_get_main_queue(), {
                            if success == 0 {
                                
                                self.performSegueWithIdentifier("showClock", sender: json)
                                
                            } else {
                                print(self.switchCode(success))
                                
                                let alert = UIAlertController(title: "Login fail", message: self.switchCode(success), preferredStyle: UIAlertControllerStyle.Alert)
                                
                                let ok = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
                                    
                                    print("Ok pressed")
                                    
                                }
                                
                                alert.addAction(ok)
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                                
                                
                            }
                        })
                    } else {
                        print("Program should crash here")
                    }
                    
                    
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)    // No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)                                                          // Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        
        task.resume()
        
    }
    
    func switchCode(success: Int?) -> String {
        
        
        let status = success!
        
        switch (status) {
        case 0:
            return "Success action";
        case 1:
            return"Company with this name doesn`t exist";
        case 2:
            return"Incorrect password";
        case 3:
            return "You are not near by with office";
        case 4:
            return "Incorrect IP for this company";
        case 5:
            return "Incorrect data";
        case 6:
            return "Token doesn't exist";
        case 7:
            return "Incorrect identifier";
        case 8:
            return "You aren't member of this company!";
        case 9:
            return "There is not users in this company!";
        case 13:
            return "Company doesn't allow employee device login";
        default: return "=======";
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showClock" {
            let viewController:ClockViewController = segue.destinationViewController as! ClockViewController
            viewController.JSONFromKeypad = sender as! [String : AnyObject]
            viewController.isSuperUser = self.isSuperUser
            viewController.userOption = self.userOption
        }
    }

    



}
