//
//  PopOverViewController.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/17/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet weak var dateTimeSelected: UIDatePicker!
    
    var delegate : AddAThingVCGetDateProtocol?;
    
    @IBAction func SelectDate_Click(sender: UIBarButtonItem) {

        if(self.delegate != nil)
        {
            self.delegate?.SetDate(dateTimeSelected.date)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
