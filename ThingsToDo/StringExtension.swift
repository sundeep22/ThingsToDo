//
//  StringExtension.swift
//  ThingsToDo
//
//  Created by Sundeep Suram on 5/11/16.
//  Copyright © 2016 Sundeep Suram. All rights reserved.
//

import Foundation

extension String {
    var camelCasedString: String {
        let source = self
        if source.characters.contains(" ") {
            let first = source.substringToIndex(source.startIndex.advancedBy(1))
            let cammel = NSString(format: "%@", (source as NSString).capitalizedString.stringByReplacingOccurrencesOfString(" ", withString: " ", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercaseString.substringToIndex(source.startIndex.advancedBy(1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
}