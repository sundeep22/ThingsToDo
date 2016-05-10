//
//  AddAThingVC.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/6/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class AddAThingVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    let da: TasksDA = TasksDA();
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtBoxTitle: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var dtPickerCompleteBy: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        txtViewDescription.delegate = self
        txtBoxTitle.delegate = self
        txtViewDescription.text = "Task Desciption (Optional)"
        txtViewDescription.textColor = UIColor.lightGrayColor()

        dtPickerCompleteBy.datePickerMode = UIDatePickerMode.DateAndTime;
        
        
        
        txtBoxTitle.autocapitalizationType = UITextAutocapitalizationType.Words;
        // Do any additional setup after loading the view.
    }
    

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            let point = dtPickerCompleteBy.frame;
            scrollView.scrollRectToVisible(point, animated: true)
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
        
        currentTask.taskId = 0;
        currentTask.taskTitle = txtBoxTitle.text;
        currentTask.taskDescription = txtViewDescription.text;
        currentTask.taskDeadline = dtPickerCompleteBy.date;
        currentTask.taskStatusId = TaskStatusEnum.Pending.rawValue;
        currentTask.taskCreatedOn = NSDate();
    
        let validationResults = currentTask.validateTaskVM();
        
        if validationResults.valid
        {
            
            da.StoreTaskInDB(currentTask);
            NSNotificationCenter.defaultCenter().postNotificationName("loadTasks", object: nil)
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            MyUIHelper.ShowError(self, userMessage: validationResults.ErrorMessage);
        }
    
    }
}
