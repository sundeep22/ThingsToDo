//
//  TaskDisplayCell.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/14/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class TaskDisplayCell: UITableViewCell {

    
    var task: TaskVM = TaskVM()
    var taskUniqueID: String?;
    let tasksDA = TasksDA()
    
    @IBOutlet weak var viewForDateAndtime: UIView!
    @IBOutlet weak var taskStatusIndicator: UIView!
    @IBOutlet weak var lblTaskName: UILabel!
    @IBOutlet weak var lblDeadlineDay: UILabel!
    @IBOutlet weak var lblDeadlineTime: UILabel!
    @IBOutlet weak var btnStarIt: UIButton!
    
    weak var delegate : ViewControllerProtocol?
    
    static let reuseIdentifier = "taskCell"
    
//    func doSomethingWhenTapped() {
//        // TODO: actually set up the cell so this method is called when tapped
//        if let parentSearchData = self.delegate?.updateAndRefreshData() {
//            
//                
//        } else {
//            print("Something is wrong, this cell's delegate wasn't set...")
//        }
//    }
    
    
    @IBAction func btnStarCurrentTask(sender: UIButton) {
        
        print(task);
        
        if task.isStarred == 0
        {
            self.tasksDA.SetStarValueToTask(task.uniqueIdentifier!, starred: 1)
            self.btnStarIt.setImage(UIImage(named: "starLit.png"), forState: UIControlState.Normal)
            self.task.isStarred = 1;
        }
        else
        {
            self.tasksDA.SetStarValueToTask(task.uniqueIdentifier!, starred: 0)
            self.btnStarIt.setImage(UIImage(named: "starDull.png"), forState: UIControlState.Normal)
            self.task.isStarred = 0;
        }
        self.delegate?.updateAndRefreshData()
        //doSomethingWhenTapped()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
