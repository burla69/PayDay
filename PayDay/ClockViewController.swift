//
//  ClockViewController.swift
//  PayDay
//
//  Created by Oleksandr Burla on 3/15/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit
import AVFoundation
import DropDown


class ClockViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fullDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var clockInButton: UIButton!
    @IBOutlet weak var clockOutButton: UIButton!
    @IBOutlet weak var clockInLabel: UILabel!
    @IBOutlet weak var clockOutLabel: UILabel!
    
    let dropDown = DropDown()
    
    
    @IBOutlet weak var cameraView: UIView!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCaptureStillImageOutput!
    
    var JSONFromKeypad = [String: AnyObject]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isSuperUser = 0
    
    
    
    var location = ""
    var token = ""
    var firstName = ""
    var lastName = ""
    var time = ""
    var date = ""
    var base64String = ""
    var userOption = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showVideoView()
        
        
        updateDataFrom(JSONFromKeypad)
        
        self.nameLabel.text = "Hi, \(firstName)"
        self.timeLabel.text = time
        self.locationLabel.text = location
        self.fullDateLabel.text = date
        
        
        let view = UIView(frame: CGRectMake(self.view.frame.maxX - 150, 60,100,100))
        self.view.addSubview(view)
        dropDown.anchorView = view
        dropDown.direction = .Any
        dropDown.width = 150
        
        
        let rightMenuButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "rightMenuItemSelected")
        rightMenuButton.tintColor = UIColor(red:0.98, green:0.75, blue:0.00, alpha:1.0)
        
        if self.userOption == 0 {
            print("user option = 0")
        } else if self.userOption == 1 {
            print("user option = 1")
        } else if self.userOption == 2 {
            print("user option = 2")
            dropDown.dataSource = ["Break"]
            self.navigationItem.setRightBarButtonItem(rightMenuButton, animated: false);
        } else if self.userOption == 3 {
            print("user option = 3")
            dropDown.dataSource = ["Break", "Call Back for Duty"]
            self.navigationItem.setRightBarButtonItem(rightMenuButton, animated: false);
        }
        
        
        
        
        
        
        
        dropDown.selectionAction = { (index, item) in
            
            if index == 0 {
                self.clockInButton.backgroundColor = UIColor(red:0.98, green:0.75, blue:0.00, alpha:1.0)
                self.clockInLabel.text = "START BREAK"
                self.clockInLabel.textColor = UIColor(red:0.98, green:0.75, blue:0.00, alpha:1.0)
                self.clockOutLabel.text = "STOP BREAK"
                
                
            } else if index == 1{
                self.clockInButton.backgroundColor = UIColor(red:0.00, green:0.62, blue:0.23, alpha:1.0)
                self.clockInLabel.text = "DUTY IN"
                self.clockInLabel.textColor = UIColor(red:0.00, green:0.62, blue:0.23, alpha:1.0)
                self.clockOutLabel.text = "DUTY OUT"

            }
            
        }
                
    }
    
    
    
    func showVideoView() {
        guard
            let captureDevice = (AVCaptureDevice.devices()
                .filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == .Front})
                .first as? AVCaptureDevice
            else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width-80)
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            //
            let stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
            if captureSession!.canAddOutput(stillImageOutput){
                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                captureSession!.addOutput(stillImageOutput)
                
                self.stillImageOutput = stillImageOutput
            }
            //
            
            
        } catch {
            print(error)
            return
        }
        
    }

    
    @IBAction func clockInPressed(sender: UIButton) {
        
        let message = (self.clockInLabel.text)!
        
        let alert = UIAlertController(title: message, message: "Confirm to \(message)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let ok = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
            
            self.takePhoto()
            
            var checkInType = ""
            
            if (self.clockInLabel.text)! == "CLOCK IN" {
                checkInType = "Check In"
            } else if (self.clockInLabel.text)! == "CLOCK OUT" {
                checkInType = "Check Out"
            } else if (self.clockInLabel.text)! == "START BREAK" {
                checkInType = "Break In"
            } else if (self.clockInLabel.text)! == "START STOP" {
                checkInType = "Break Out"
            } else if (self.clockInLabel.text)! == "DUTY IN" {
                checkInType = "Duty In"
            } else if (self.clockInLabel.text)! == "DUTY OUT" {
                checkInType = "Duty Out"
            }
            
            
            let params = [          "token": self.token,
                            "check_in_type": checkInType,
                                    "photo": self.base64String]
            
            
            print((self.clockInButton.titleLabel?.text)!)
            
            self.postRequest("/api/v1/users/check-in/", params: params, type: message)
            
        }
        
        alert.addAction(ok)
        
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func clockOutPressed(sender: UIButton) {
        
        let message = (self.clockOutLabel.text)!
        
        let alert = UIAlertController(title: message, message: "Confirm to \(message)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let ok = UIAlertAction(title: "Yes", style: .Default) { (action) -> Void in
            
            self.takePhoto()
            
            let params = [          "token": self.token,
                                    "check_in_type": (sender.titleLabel?.text)!,
                                    "photo": self.base64String]
            
            
            self.postRequest("/api/v1/users/check-in/", params: params, type: message)
            
            
        }
        
        alert.addAction(ok)
        
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func rightMenuItemSelected() {
        dropDown.show()

    }
    
    
    func updateDataFrom(json: [String : AnyObject]) {
        
        self.location = (json["location"] as? String)!
        self.token = (json["token"] as? String)!
        self.time = (json["time"] as? String)!
        self.date = (json["date"] as? String)!
        let user = (json["user"] as? [String : AnyObject])!
        self.firstName = (user["first_name"] as? String)!

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: POST func
    
    func postRequest(path: String, params: [String: AnyObject], type: String) {
        
        let baseURL = "http://ec2-52-34-242-50.us-west-2.compute.amazonaws.com"
        
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
                return
            }
            
            // this, on the other hand, can quite easily fail if there's a server error, so you definitely
            // want to wrap this in `do`-`try`-`catch`:
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    //print(json)

                    
                    if let success = json["status"] as? Int {
                        print(success)
                        dispatch_async(dispatch_get_main_queue(), {
                            if success == 0 {
                                
                                let dopDataArray = [json, type, self.firstName]
                                
                                self.performSegueWithIdentifier("showSuccess", sender: dopDataArray)

                                
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
        
        self.activityIndicator.stopAnimating()

        
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
        if segue.identifier == "showSuccess" {
            let viewController:SuccessViewController = segue.destinationViewController as! SuccessViewController
            
            let dataArray = sender as! NSArray
            
            viewController.JSONFromClock = dataArray[0] as! [String : AnyObject]
            viewController.statusSuccess = dataArray[1] as! String
            viewController.name = dataArray[2] as! String
            viewController.isSuperUser = self.isSuperUser

            
        }
    }
    
    func takePhoto() {
        
        self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)) { (buffer:CMSampleBuffer!, error:NSError!) -> Void in
            let image = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            let data_image = UIImage(data: image)
            self.captureSession?.stopRunning()
            self.activityIndicator.startAnimating()

            
            let imageData = UIImagePNGRepresentation(data_image!)
            self.base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            
        }
        
    }
    
}
