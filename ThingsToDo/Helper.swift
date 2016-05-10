//
//  Helper.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/7/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit

struct MyUIHelper {
    
    static func ShowError(sender: UIViewController, userMessage: String?)
    {
        let alertController = UIAlertController(title: "Error", message:
            userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        sender.presentViewController(alertController, animated: true, completion: nil)
    }
}