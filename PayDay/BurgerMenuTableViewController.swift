//
//  BurgerMenuTableViewController.swift
//  PayDay
//
//  Created by Oleksandr Burla on 4/19/16.
//  Copyright © 2016 Oleksandr Burla. All rights reserved.
//

import UIKit

protocol BurgerMenuTableViewControllerDelegate {
    func selectedFromBurgerMenuTableViewController(string: String)
}

class BurgerMenuTableViewController: UITableViewController {
    
    var delegate: BurgerMenuTableViewControllerDelegate!
    
    var userOption = 0
    var dataSource: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("User OPTION: \(userOption)")

        
//        
//        if self.userOption == 0 {
//            print("user option = 0")
//        } else if self.userOption == 1 {
//            print("user option = 1")
//            dropDown.dataSource = ["Break"]
//            //self.navigationItem.setRightBarButtonItem(rightMenuButton, animated: false);
//        } else if self.userOption == 2 {
//            print("user option = 2")
//            dropDown.dataSource = ["Call Back Duty"]
//            //self.navigationItem.setRightBarButtonItem(rightMenuButton, animated: false);
//        } else if self.userOption == 3 {
//            print("user option = 3")
//            dropDown.dataSource = ["Break", "Call Back Duty"]
//            //self.navigationItem.setRightBarButtonItem(rightMenuButton, animated: false);
//        }
        
        
        if userOption == 0 {
            dataSource = ["Support"]
        } else if self.userOption == 1 {
            dataSource = ["Break", "Support"]
        } else if self.userOption == 2 {
            dataSource = ["Call Back Duty", "Support"]
        } else if self.userOption == 3 {
            dataSource = ["Break", "Call Back Duty", "Support"]
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = dataSource[indexPath.row] as? String
        cell.textLabel?.textColor = UIColor.whiteColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        self.delegate.selectedFromBurgerMenuTableViewController((cell?.textLabel?.text)!)
        
        dismissViewControllerAnimated(true, completion: nil)
        
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
