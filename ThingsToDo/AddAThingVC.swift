//
//  AddAThingVC.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/6/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class AddAThingVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, AddAThingVCGetDateProtocol {

    let da: TasksDA = TasksDA();
    let taskGroupDA = TaskGroupsDA();
    var taskGroup = TaskGroupsVM?()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtBoxTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    //@IBOutlet weak var dtPickerCompleteBy: UIDatePicker!
    @IBOutlet weak var lblSelectedDate: UILabel!
    
    @IBOutlet weak var btnClearDate: UIButton!
    @IBOutlet weak var ShowDateView: UIView!
    
    @IBOutlet weak var AddTaskButton: UIButton!
    var selectedCompleteByDate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        AddTaskButton.backgroundColor = MyUIHelper.GetHeaderBlue1()
        AddTaskButton.layer.cornerRadius = 5
        AddTaskButton.layer.borderWidth = 1
        AddTaskButton.layer.borderColor = MyUIHelper.GetHeaderBlue1().CGColor
        //AddTaskButton.tintColor = UIColor.whiteColor()
        


        self.hideKeyboardWhenTappedAround()
        txtViewDescription.delegate = self
        txtBoxTitle.delegate = self
        txtViewDescription.text = "Task Desciption (Optional)"
        txtViewDescription.textColor = UIColor.lightGrayColor()

        self.ShowDateView.hidden = true
        
        //dtPickerCompleteBy.datePickerMode = UIDatePickerMode.DateAndTime;
        
        btnClearDate.layer.cornerRadius = 5
        btnClearDate.layer.borderWidth = 1
        btnClearDate.layer.backgroundColor = MyUIHelper.GetThemeRed().CGColor
        btnClearDate.layer.borderColor = MyUIHelper.GetThemeRed().CGColor
        
        
        txtBoxTitle.autocapitalizationType = UITextAutocapitalizationType.Words;
        // Do any additional setup after loading the view.
    }
    

    @IBAction func AddTask_Click(sender: UIButton) {
        done_AddingAThing(sender)
    }
    func SetDate(dateSelected : NSDate)
    {
        print("Got Date!!")
        self.selectedCompleteByDate = dateSelected;
        lblSelectedDate.text = dateSelected.ToLocalStringWithFormat("MM/dd/yyyy hh:mm a")
        self.ShowDateView.hidden = false

    }

    @IBAction func clearDate_Click(sender: UIButton) {
        
        self.selectedCompleteByDate = nil
        lblSelectedDate.text = ""
        self.ShowDateView.hidden = true
        
    }
    @IBAction func selectDeadline_Click(sender: UIButton) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("SelectDeadline_Scene") as! PopOverViewController
        vc.delegate = self
        vc.preferredContentSize = CGSize(width: 320, height: 260)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        
        navController.navigationBarHidden = true
        
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.sourceView = sender
        popOver?.sourceRect = sender.bounds;
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.Any;
        
        
        
        
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
//            let point = dtPickerCompleteBy.frame;
//            scrollView.scrollRectToVisible(point, animated: true)
            return false;
        }
        
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.txtBoxTitle
        {
            textField.resignFirstResponder()
            txtViewDescription.becomeFirstResponder()
            //txtViewDescription.text = nil;
            let point = txtViewDescription.frame;
            scrollView.scrollRectToVisible(point, animated: true)
            
            //scrollView.setContentOffset(CGPointMake(point.minX - 20, point.minY - 20), animated: true)

        }
        return false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if txtViewDescription.textColor == UIColor.lightGrayColor() {
            txtViewDescription.text = nil
            txtViewDescription.textColor = UIColor.blackColor()
        }
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if txtViewDescription.text.isEmpty {
            txtViewDescription.text = "Task Desciption (Optional)"
            txtViewDescription.textColor = UIColor.lightGrayColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func done_AddingAThing(sender: AnyObject)
    {
        
        self.view.endEditing(true)
        
        print("trying to store")
        var currentTask = TaskVM()
        
        currentTask.taskTitle = txtBoxTitle.text;
        
        if(txtViewDescription.textColor != UIColor.lightGrayColor() && txtViewDescription.text != "Task Desciption (Optional)")
        {
            currentTask.taskDescription = txtViewDescription.text;
        }
        currentTask.taskDeadline = self.selectedCompleteByDate;
        currentTask.taskStatusId = TaskStatusEnum.Pending.rawValue;
        currentTask.isStarred = 0
        currentTask.taskCreatedOn = NSDate();
        
        if(taskGroup != nil)
        {
            currentTask.taskGroup = taskGroup;
        }
        let validationResults = currentTask.validateTaskVM();
        
        if validationResults.valid
        {
            currentTask.objectID = da.StoreTaskInDB(currentTask);
            if(currentTask.taskDeadline != nil)
            {
                MyNotificationCenter.AddNotificationForTaskVM(currentTask);
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("loadTasks", object: nil)
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            MyUIHelper.ShowError(self, userMessage: validationResults.ErrorMessage);
        }
    
    }
}

protocol AddAThingVCGetDateProtocol
{
    func SetDate(dateSelected : NSDate)
}
