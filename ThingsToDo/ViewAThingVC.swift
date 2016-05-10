//
//  ViewAThingVC.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/7/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class ViewAThingVC: UIViewController {

    
    let da = TasksDA();
    
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var txtViewTaskDescription: UITextView!
    @IBOutlet weak var lblCompleteBy: UILabel!
    
    @IBOutlet weak var btnMarkAsCompletedTask: UIButton!
    
    var SelectedTask: TaskVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if(SelectedTask!.taskTitle != nil && SelectedTask!.taskTitle != "")
        {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            
            lblTaskTitle.text = SelectedTask!.taskTitle;
            txtViewTaskDescription.text = SelectedTask!.taskDescription;
            
            lblCompleteBy.text = SelectedTask!.taskDeadline!.ToLocalStringWithFormat("MM/dd/yyyy hh:mm a")
            
            if SelectedTask!.taskStatusId == TaskStatusEnum.Completed.rawValue
            {
                btnMarkAsCompletedTask.hidden = true;
            }
            
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func btnDeleteTask_Click(sender: UIButton) {
        
        da.DeleteATask(SelectedTask!);
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTasks", object: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btnMarkAsCompletedTask_Click(sender: UIButton) {
        SelectedTask!.taskStatusId = TaskStatusEnum.Completed.rawValue;
        da.UpdateTaskInDB(SelectedTask!);
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTasks", object: nil)
        navigationController?.popViewControllerAnimated(true)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
