//
//  ViewController.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/6/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let showOnlyPendingTasks = true;
    
    var currentTaskGroup =  TaskGroupsVM?()
    var automaticTaskGroup: AutomaticTaskGroupEnum? = nil
    
    @IBOutlet weak var txtFieldSearchTasks: UITextField!
    @IBOutlet weak var uiSwitchShowCompleted: UISwitch!
    let da: TasksDA = TasksDA();
    let groupsDA = TaskGroupsDA();
    let appSettingsDA = AppSettingsDA()
    var allTasks = [TaskVM]();
    var filteredTasks = [TaskVM]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tblViewTasks: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
        
        print("Received \(currentTaskGroup)")
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        self.SetShowCompletedTasksSwitch()
        
        self.allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "")
        
        //self.tblViewTasks.rowHeight = 70.0
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        tblViewTasks.tableHeaderView = searchController.searchBar
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.loadList(_:)),name:"loadTasks", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reloadList(_:)),name:"reloadTasks", object: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
            case 0:
                if searchController.active && searchController.searchBar.text != "" {
                    return filteredTasks.count
                }
                return allTasks.count
            default:
                return 0;
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return currentTaskGroup?.taskGroupName;
        }
        else
        {
            return "Unidentified Seciton"
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("segueToTaskDetails", sender: indexPath.row)
        tblViewTasks.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = MyUIHelper.GetHeaderBlue1()
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        //header.alpha = 0.8 //make the header transparent
    }

    
    
    @IBAction func showCompleted_ValueChanged(sender: UISwitch) {
       
        if uiSwitchShowCompleted.on
        {
            appSettingsDA.UpdateAppSetting("ShowCompletedTasks", value: "True")
        }
        else
        {
            appSettingsDA.UpdateAppSetting("ShowCompletedTasks", value: "False")   
        }
       
        allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "");
        tblViewTasks.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Preparing \(segue.identifier)")
        
        if(segue.identifier == "segueToTaskDetails") {
            let currentIndex = sender as! Int;
            
            let currentTask: TaskVM
            if searchController.active && searchController.searchBar.text != "" {
                currentTask = filteredTasks[currentIndex]
            } else {
                currentTask = allTasks[currentIndex]
            }
            
            let currentItem = currentTask;
            
            let targetController = (segue.destinationViewController as! ViewAThingVC)
            
            targetController.SelectedTask = currentItem;
        
        }
        else if(segue.identifier == "segueToAddTask")
        {
            let targetController = (segue.destinationViewController as! AddAThingVC)
            
            targetController.taskGroup = currentTaskGroup;
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func DeleteTaskAndRefreshTable(taskVM: TaskVM)
    {
        da.DeleteATask(taskVM);
        MyNotificationCenter.DeleteNotificationsForTaskVM(taskVM)
        allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "")
        filterContentForSearchText(searchController.searchBar.text!)
    }

    func MarkTaskAsDone(taskVM: TaskVM)
    {
        var taskVM = taskVM;
        taskVM.taskStatusId = TaskStatusEnum.Completed.rawValue;
        self.da.UpdateTaskInDB(taskVM);
        MyNotificationCenter.DeleteNotificationsForTaskVM(taskVM)
        allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "")
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func MarkTaskAsPending(taskVM: TaskVM)
    {
        var taskVM = taskVM;
        taskVM.taskStatusId = TaskStatusEnum.Pending.rawValue;
        self.da.UpdateTaskInDB(taskVM);
        allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "")
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        var taskDetail: TaskVM
        if searchController.active && searchController.searchBar.text != "" {
            taskDetail = filteredTasks[indexPath.row]
        } else {
            taskDetail = allTasks[indexPath.row]
        }
        
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            self.DeleteTaskAndRefreshTable(taskDetail)
        })
        delete.backgroundColor = UIColor.redColor()
        
        
        if taskDetail.taskStatusId == TaskStatusEnum.Completed.rawValue
        {
            let markAsPending = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Mark as Pending" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                
                
                self.MarkTaskAsPending(taskDetail);
            })
            markAsPending.backgroundColor = UIColor.lightGrayColor()
            
            return [delete, markAsPending]
        }
        else
        {
            let markAsDone = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Mark as Done" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            
                self.MarkTaskAsDone(taskDetail);
        })
            markAsDone.backgroundColor = MyUIHelper.CreateUIColorFromCodes(2, green: 195, blue: 154, alpha: 1)
        
            return [delete, markAsDone]
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let newCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "taskTableCell");

        
        let newCell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as! TaskDisplayCell
        
        newCell.detailTextLabel?.textColor = UIColor.darkGrayColor()
//        newCell.textLabel?.textColor = UIColor.redColor()
//        //newCell.textLabel?.font = UIFont.boldSystemFontOfSize(20.0);
//        newCell.textLabel?.font = UIFont(name: "DJBMyBoyfriend'sHandwriting", size: 20.0)
        
        let taskDetail: TaskVM
        if searchController.active && searchController.searchBar.text != "" {
            taskDetail = self.filteredTasks[indexPath.row]
        } else {
            taskDetail = self.allTasks[indexPath.row]
        }
        
        if indexPath.row % 2 != 0
        {
            newCell.viewForDateAndtime.backgroundColor = UIColor(hexString: "#F6F6F6F6")
            newCell.backgroundColor = UIColor(hexString: "#F6F6F6F6")
        }
        else
        {
            newCell.backgroundColor = UIColor.whiteColor()
            newCell.viewForDateAndtime.backgroundColor = UIColor.whiteColor()

        }
        
        if taskDetail.taskStatusId == TaskStatusEnum.Pending.rawValue
        {
            newCell.taskStatusIndicator.backgroundColor = MyUIHelper.CreateUIColorFromCodes(193, green: 73, blue: 58, alpha: 1)
        }
        else
        {
            newCell.taskStatusIndicator.backgroundColor = MyUIHelper.CreateUIColorFromCodes(2, green: 195, blue: 154, alpha: 1)
        }
        
        
//        let image : UIImage? = UIImage(named: imageToShow)
//        
//        newCell.imageView?.image = image;
        newCell.lblTaskName.text = taskDetail.taskTitle;
        
        if(taskDetail.taskDeadline != nil)
        {
            newCell.lblDeadlineDay.text = MyUIHelper.GetDayOrMonth(taskDetail.taskDeadline!)
            newCell.lblDeadlineTime.text = MyUIHelper.GetTimeOrDay(taskDetail.taskDeadline!)
        }
        else
        {
            newCell.lblDeadlineDay.text = ""
            newCell.lblDeadlineTime.text = ""
        }
        
        
        newCell.taskUniqueID = taskDetail.uniqueIdentifier
        newCell.delegate = self
        let bgColorView = UIView()
        bgColorView.backgroundColor = MyUIHelper.CreateUIColorFromCodes(193, green: 73, blue: 58, alpha: 1)
        newCell.selectedBackgroundView = bgColorView

        
        if taskDetail.isStarred == 0
        {
            newCell.btnStarIt.setImage(UIImage(named: "starDull.png"), forState: UIControlState.Normal)
        }
        else
        {
            newCell.btnStarIt.setImage(UIImage(named: "starLit.png"), forState: UIControlState.Normal)
        }
        newCell.task = taskDetail
        
        return newCell;
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //only one for now, until we implement sections
        return 1;
    }
    
    @IBAction func searchButton_ValueChanged(sender: UITextField) {
        
        print("Text Box Value Changed")
        
        for index in 0...tblViewTasks.numberOfRowsInSection(0)
            {
                let cell = tblViewTasks.cellForRowAtIndexPath(NSIndexPath(forItem: index, inSection: 0))
                
                print(cell?.textLabel!.text!)
                print(sender.text!)
                
                if ((cell?.textLabel!.text!.hasPrefix(sender.text!)) == nil)
                {
                    print("setting up as true")
                    cell?.hidden = true;
                }
                else
                {
                    print("setting up as false")
                    cell?.hidden = false;
                }
            }
        
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
         filteredTasks = allTasks.filter { task in
            return task.taskTitle!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tblViewTasks.reloadData()
    }
    
    func SetShowCompletedTasksSwitch()
    {
        let showCompletedTasks = appSettingsDA.GetAppSettingByKey("ShowCompletedTasks");
        
        if showCompletedTasks == "True"
        {
            uiSwitchShowCompleted.on = true;
        }
        else
        {
            uiSwitchShowCompleted.on = false;
        }
    }
    
   
    
    @IBAction func View_TouchDown(sender: UIView) {
        print("View Touched");
        view.endEditing(true);
    }
    func reloadList(notification: NSNotification){
        //load data here
        print("trying to refresh-reload")
        self.allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "")
        self.tblViewTasks.reloadData()
    }
    
    func loadList(notification: NSNotification){
        //load data here
        print("trying to reload")
        self.allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "")
        self.tblViewTasks.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func SortTasks(task1: TaskVM, task2: TaskVM) -> Bool
    {
        
        if(task1.taskStatusId == task2.taskStatusId)
        {
            if(task1.isStarred == task2.isStarred)
            {

                if(task1.taskDeadline == nil) { return false }
                if(task2.taskDeadline == nil) { return true }

                return(task1.taskDeadline!.isLessThanDate(task2.taskDeadline!))
            }
            else
            {
                return task1.isStarred > task2.isStarred
            }
        }
        else
        {
            return task1.taskStatusId < task2.taskStatusId
        }
    }
    
    func GetTasks(sortOrder: TaskSortTypes, filter: String) -> [TaskVM]
    {
        if automaticTaskGroup == nil && currentTaskGroup != nil
        {
        
            if sortOrder == .DateCreatedDescending && uiSwitchShowCompleted.on
            {
                return self.groupsDA.GetAllTasksForTaskGroups(currentTaskGroup!)
                    .sort(SortTasks)
            
            }
            else if sortOrder == .DateCreatedDescending && !uiSwitchShowCompleted.on
            {
                return self.groupsDA.GetAllTasksForTaskGroups(currentTaskGroup!)
                    .filter({$0.taskStatusId != TaskStatusEnum.Completed.rawValue })
                    .sort(SortTasks)
            }
            else
            {
                return self.groupsDA.GetAllTasksForTaskGroups(currentTaskGroup!);
            }
        }
        else if automaticTaskGroup != nil
        {
            if automaticTaskGroup == AutomaticTaskGroupEnum.TodaysTasks
            {
                let today = NSDate()
                let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                let startTime = cal.startOfDayForDate(today)
                let endTime = cal.dateBySettingHour(23, minute: 59, second: 59, ofDate: today, options: NSCalendarOptions.MatchNextTime)
                
                if(uiSwitchShowCompleted.on)
                {
                    return self.da.GetAllTasks()
                        .filter({$0.taskDeadline != nil})
                        .filter( { return $0.taskDeadline! >= startTime && $0.taskDeadline! < endTime} )
                        .sort(SortTasks)
                }
                else
                {
                   return self.da.GetAllTasks()
                    .filter({$0.taskDeadline != nil})
                    .filter({$0.taskStatusId != TaskStatusEnum.Completed.rawValue })
                    .filter( { return $0.taskDeadline! >= startTime && $0.taskDeadline! < endTime} )
                    .sort(SortTasks)
                }
            }
            else if automaticTaskGroup == AutomaticTaskGroupEnum.TomorrowsTasks
            {
                
                let date = NSDate()
                let tomorrow = date.dateByAddingTimeInterval(24 * 60 * 60)
                let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                
                let startTime = cal.startOfDayForDate(tomorrow)
                let endTime = cal.dateBySettingHour(23, minute: 59, second: 59, ofDate: tomorrow, options: NSCalendarOptions.MatchNextTime)
                
                if(uiSwitchShowCompleted.on)
                {
                    return self.da.GetAllTasks()
                        .filter({$0.taskDeadline != nil})
                        .filter( { return $0.taskDeadline! >= startTime && $0.taskDeadline! < endTime} )
                        .sort(SortTasks)
                }
                else
                {
                     return self.da.GetAllTasks()
                        .filter({$0.taskDeadline != nil})
                        .filter({$0.taskStatusId != TaskStatusEnum.Completed.rawValue }).filter( { return $0.taskDeadline! >= startTime && $0.taskDeadline! < endTime} )
                        .sort(SortTasks)
                }
            }
            else if automaticTaskGroup == AutomaticTaskGroupEnum.ThisWeeksTasks
            {
                let startDate = MyUIHelper.get(.Previous, "Sunday", considerToday: true)
                let endDate = MyUIHelper.get(.Next, "Saturday", considerToday: true)
                
                let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
                
                let startTime = cal.startOfDayForDate(startDate)
                let endTime = cal.dateBySettingHour(23, minute: 59, second: 59, ofDate: endDate, options: NSCalendarOptions.MatchNextTime)
                
                if(uiSwitchShowCompleted.on)
                {
                    return self.da.GetAllTasks()
                        .filter({$0.taskDeadline != nil})
                        .filter( { return $0.taskDeadline! >= startTime && $0.taskDeadline! < endTime} )
                        .sort(SortTasks)
                }
                else
                {
                    return self.da.GetAllTasks()
                        .filter({$0.taskDeadline != nil})
                        .filter({$0.taskStatusId != TaskStatusEnum.Completed.rawValue })
                        .filter( { return $0.taskDeadline! >= startTime && $0.taskDeadline! < endTime} )
                        .sort(SortTasks)
                }
            }
        }
        return [TaskVM]()
    
    
    }

}


protocol ViewControllerProtocol : class {    // 'class' means only class types can implement it
    func updateAndRefreshData()
}

extension ViewController: UISearchResultsUpdating, ViewControllerProtocol {
    
    func updateAndRefreshData() {
        self.allTasks = self.GetTasks(TaskSortTypes.DateCreatedDescending, filter: "")
        self.tblViewTasks.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
