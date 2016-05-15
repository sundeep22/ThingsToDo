//
//  UIViewControllerExtension.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/7/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

