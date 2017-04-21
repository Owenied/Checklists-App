//
//  Checklist.swift
//  Checklists
//
//  Created by Owen Duignan on 18/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    // Necessary method for NSCoding
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    // Initialise a Checklist item properties (for the checklist categories)
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    // Initialise the setting of the icon name
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // Necessary method for NSCoding - load and save the Checklist's Name and Item properties
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    // Method to count remaining items to be completed
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
}
