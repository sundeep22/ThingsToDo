//
//  AppSettings.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/9/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import Foundation


import UIKit
import CoreData

@objc(AppSettings)
class AppSettings : NSManagedObject {
    
    @NSManaged var settingName: String?;
    @NSManaged var settingValue: String?;
}