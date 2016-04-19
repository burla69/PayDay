//
//  TermsViewController.swift
//  PayDay
//
//  Created by Oleksandr Burla on 4/19/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterButton.userInteractionEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switcherAction(sender: UISwitch) {
        
        if sender.on {
            enterButton.userInteractionEnabled = true
        } else {
            enterButton.userInteractionEnabled = false
        }
        
    }

    @IBAction func enterButtonPressed(sender: UIButton) {
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "TermsAccepted")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func termsAndConditionsPressed(sender: UIButton) {
        
        self.performSegueWithIdentifier("showTermsText", sender: nil)
        
    }
    
    @IBAction func unwindToTerms(segue: UIStoryboardSegue) {
        
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
