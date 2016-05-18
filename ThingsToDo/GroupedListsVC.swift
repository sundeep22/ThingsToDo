//
//  GroupedListsVC.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/11/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class GroupedListsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
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
//        self.tblViewTaskGroups.registerClass(UITableViewCell.self, forCellReuseIdentifier: "taskGroup")
////        self.tblViewTaskGroups.registerNib(UINib(nibName: "GroupDisplayCell", bundle: nil), forCellReuseIdentifier: "taskGroup")
        
//        self.navigationController?.navigationBar.translucent = true
//        self.navigationController?.navigationBar.barTintColor = MyUIHelper.CreateUIColorFromCodes(0, green: 84, blue: 138, alpha: 1.0)
//    
        
        self.tblViewTaskGroups.dataSource = self;
        self.tblViewTaskGroups.delegate = self;
        
        super.viewDidLoad()
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
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
            textField.autocorrectionType = UITextAutocorrectionType.Yes

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
        header.contentView.backgroundColor = MyUIHelper.GetHeaderBlue1()
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        //header.alpha = 0.8 //make the header transparent
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath;
    }
    

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("taskGroup", forIndexPath: indexPath)

        
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "taskGroup");
        let cell = self.tblViewTaskGroups.dequeueReusableCellWithIdentifier("taskGroup", forIndexPath: indexPath) as! GroupDisplayCell
//    
//        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
//        cell.textLabel?.textColor = UIColor.darkGrayColor()
//        cell.textLabel?.font = UIFont(name: "DJBMyBoyfriend'sHandwriting", size: 30.0)
        
        //cell.imageStatusColor!.image = UIImage(named: "blueBar.png")
        
        
        //cell.textLabel?.font = UIFont.boldSystemFontOfSize(20.0);
        
//        if (indexPath.row % 2 == 0)
//        {
//            cell.backgroundColor = colorForIndex(indexPath.row)
//        } else {
//            cell.backgroundColor = UIColor.whiteColor()
//        }
        
        
//        if indexPath.section == 0
//        {
//            //cell.imageView!.image = UIImage(named: "blueBar.png")
//            cell.textLabel!.text = staticRows[indexPath.row]        }
//        else if indexPath.section == 1
//        {
//            cell.textLabel!.text = allTaskGroups[indexPath.row].taskGroupName
//        }

            
        if indexPath.section == 0
        {
            cell.imageStar!.image = UIImage(named: "starLit.png")
            //cell.imageView!.image = UIImage(named: "blueBar.png")
            cell.lblTitle.text = staticRows[indexPath.row]
            if(indexPath.row == 0)
            {
                cell.taskStatusIndicator.backgroundColor = MyUIHelper.CreateUIColorFromCodes(209, green: 73, blue: 91, alpha: 1)
            }
            else if(indexPath.row == 1)
            {
                cell.taskStatusIndicator.backgroundColor = MyUIHelper.CreateUIColorFromCodes(237, green: 174, blue: 73, alpha: 1)
            }
            else if(indexPath.row == 2)
            {
                cell.taskStatusIndicator.backgroundColor = MyUIHelper.CreateUIColorFromCodes(176, green: 219, blue: 67, alpha: 1)
            }
            
            
        }
        else if indexPath.section == 1
        {
            cell.lblTitle.text = allTaskGroups[indexPath.row].taskGroupName
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = MyUIHelper.CreateUIColorFromCodes(193, green: 73, blue: 58, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        //cell.selectedBackgroundView?.backgroundColor =
        
        return cell;
        
    }
    

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return indexPath.section == 1 ? true : false
    }
    
    func DeleteTaskGroupAndRefreshTable(taskGroup: TaskGroupsVM)
    {
        let refreshAlert = UIAlertController(title: taskGroup.taskGroupName, message: "Deleting a Task Group will delete all Tasks Associated with it. Do you wish to proceed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.taskGroupsDA.DeleteATaskGroup(taskGroup);
            //MyNotificationCenter.DeleteNotificationsForTaskVM(taskVM)
            self.RefreshAllTaskGroups()
            self.tblViewTaskGroups.reloadData()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Destructive, handler: { (action: UIAlertAction!) in
            self.tblViewTaskGroups.setEditing(false, animated: true)
        }))
        

        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }

    func MarkAllTasksAsDone(taskGroup: TaskGroupsVM)
    {
        let refreshAlert = UIAlertController(title: taskGroup.taskGroupName, message: "Are you sure you want to mark all tasks under this group as completed?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.taskGroupsDA.MarkAllTasksInTaskGroup(taskGroup, status: TaskStatusEnum.Completed);
            //MyNotificationCenter.DeleteNotificationsForTaskVM(taskVM)
            self.RefreshAllTaskGroups()
            self.tblViewTaskGroups.reloadData()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Destructive, handler: { (action: UIAlertAction!) in
            self.tblViewTaskGroups.setEditing(false, animated: true)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }

    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        if(indexPath.section == 1)
        {
            var taskGroup: TaskGroupsVM
            
            taskGroup = allTaskGroups[indexPath.row]

            
            
            
            let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                self.DeleteTaskGroupAndRefreshTable(taskGroup)
            })
            delete.backgroundColor = MyUIHelper.CreateUIColorFromCodes(193, green: 73, blue: 58, alpha: 1)

            
            var tableViewRowAction : UITableViewRowAction?
            
            if taskGroupsDA.DoesGroupHavePendingTasks(taskGroup)
            {
                tableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "All Done" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                self.MarkAllTasksAsDone(taskGroup)
                })
                tableViewRowAction!.backgroundColor = MyUIHelper.CreateUIColorFromCodes(2, green: 195, blue: 154, alpha: 1)
            }
            
            
            if(tableViewRowAction == nil)
            {
                return [delete]
            }
            else
            {
                return [delete, tableViewRowAction!]
            }
            
        }
        return nil
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
