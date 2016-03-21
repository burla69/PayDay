//
//  ViewController.swift
//  PayDay
//
//  Created by Oleksandr Burla on 3/15/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var companyTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    let baseURL = "http://ec2-52-34-242-50.us-west-2.compute.amazonaws.com"
    
    var isSuperUser = 0
    var userOption = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
    }
    
    
    func viewTapped() {
        companyTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
    @IBAction func loginButton(sender: UIButton) {
        
        let params = ["company": companyTextField.text!, "username": nameTextField.text!, "password": passwordTextField.text!, "latitude": "", "longitude": "", "allow_mobile_login" : "true"]
        
        
        self.postRequest("/api/v1/users/login/", params: params)

        
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
                return
            }
            
            
            
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    
                    if let success = json["status"] as? Int {
                        print(success)
                        print(json)
                        dispatch_async(dispatch_get_main_queue(), {
                            if success == 0 {
                                
                                let user = (json["user"] as? [String : AnyObject])!
                                self.isSuperUser = (user["is_superuser"] as? Int)!
                                self.userOption = (user["option"] as? Int)!
                                
                                
                                self.performSegueWithIdentifier("goToKeypad", sender: json)
                                
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
        if segue.identifier == "goToKeypad" {
            let viewController:KeypadViewController = segue.destinationViewController as! KeypadViewController
            viewController.JSONFromLogin = sender as! [String : AnyObject]
            viewController.isSuperUser = self.isSuperUser
            viewController.userOption = self.userOption
        }
    }
    


}

