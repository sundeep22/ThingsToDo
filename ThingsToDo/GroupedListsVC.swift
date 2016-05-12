//
//  GroupedListsVC.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/11/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class GroupedListsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let taskGroupsDA = TaskGroupsDA()
    var allTaskGroups = [TaskGroupsVM]()
    let staticRows = ["Today's Tasks", "Tomorrow's Tasks", "This Week's Tasks"]
    weak var AddAlertSaveAction: UIAlertAction?
    
    @IBOutlet weak var tblViewTaskGroups: UITableView!
    
    
    
    func RefreshAllTaskGroups()
    {
        self.allTaskGroups = taskGroupsDA.GetAllTaskGroups().sort { $0.dateCreated!.compare($1.dateCreated!) == .OrderedDescending }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
        
        RefreshAllTaskGroups();
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAddNewTaskGroup(sender: UIBarButtonItem) {

        let actionSheetController: UIAlertController = UIAlertController(title: "Add a Task Group", message: "Give your new Task Group a Name", preferredStyle: .Alert)
        
        
        // Add the text field with handler
        actionSheetController.addTextFieldWithConfigurationHandler { textField in
            //listen for changes
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GroupedListsVC.handleTextFieldTextDidChangeNotification(_:)), name: UITextFieldTextDidChangeNotification, object: textField)
            textField.textColor = UIColor.darkGrayColor()
            //textField.borderStyle = UITextBorderStyle.Bezel
            textField.placeholder = "Task Group Name"

        }
        
        
        func removeTextFieldObserver() {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: actionSheetController.textFields![0])
        }
        
        let nextAction: UIAlertAction = UIAlertAction(title: "Save", style: .Default) { action -> Void in
            if actionSheetController.textFields![0].text != ""
            {
                self.SaveTaskGroup(actionSheetController.textFields![0].text!)
                
            }
        }
        
        nextAction.enabled = false;
        self.AddAlertSaveAction = nextAction;
        
        actionSheetController.addAction(nextAction)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Destructive) { action -> Void in
            // Do Nothing
        }
        actionSheetController.addAction(cancelAction)
        
        
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    
    }
    
    
    //handler
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        AddAlertSaveAction!.enabled = textField.text?.utf16.count >= 1
    }
    
    func SaveTaskGroup(taskGroup: String)
    {
        if(taskGroup != "")
        {
            var taskGroupVM = TaskGroupsVM();
            taskGroupVM.taskGroupName = taskGroup.capitalizedString
            taskGroupVM.dateCreated = NSDate()
            taskGroupsDA.StoreTaskGroupInDB(taskGroupVM)
            RefreshAllTaskGroups()
            tblViewTaskGroups.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 3
        }
        else
        {
            return allTaskGroups.count;
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            if section == 0
            {
                return "Scheduled Groups"
            }
            else if section == 1
            {
                return "Custom Groups"
            }
            else
            {
                return "Invalid Section"
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red:51/255, green: 51/255, blue: 51/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 0.8 //make the header transparent
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath;
    }
    

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("taskGroup", forIndexPath: indexPath)

        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "taskGroup");
        //let cell = tableView.dequeueReusableCellWithIdentifier("taskGroup")!
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.textColor = UIColor.darkGrayColor()
        cell.textLabel?.font = UIFont(name: "DJBMyBoyfriend'sHandwriting", size: 30.0)
        
        //cell.textLabel?.font = UIFont.boldSystemFontOfSize(20.0);
        
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = colorForIndex(indexPath.row)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        
        if indexPath.section == 0
        {
            cell.textLabel!.text = staticRows[indexPath.row]        }
        else if indexPath.section == 1
        {
            cell.textLabel!.text = allTaskGroups[indexPath.row].taskGroupName
        }
        return cell;
        
    }
    
    
    func colorForIndex(index: Int) -> UIColor
    {
        return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        performSegueWithIdentifier("segueToTasksOfGroup", sender: indexPath)
        tblViewTaskGroups.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Preparing \(segue.identifier)")
        
        if(segue.identifier == "segueToTasksOfGroup") {
            let currentIndex = sender as! NSIndexPath;
            
//            let currentTask: TaskVM
//            if searchController.active && searchController.searchBar.text != "" {
//                currentTask = filteredTasks[currentIndex]
//            } else {
//                currentTask = allTasks[currentIndex]
//            }
            
//            let currentItem = currentTask;
            
            let targetController = (segue.destinationViewController as! ViewController)
            
            if(currentIndex.section == 0)
            {
                targetController.automaticTaskGroup = AutomaticTaskGroupEnum(rawValue:(currentIndex.row));
                targetController.currentTaskGroup = nil;
            }
            else
            {
                let currentItem = allTaskGroups[currentIndex.row];
               
                targetController.currentTaskGroup = currentItem;
            }
        }
        
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
