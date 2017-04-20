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
    
    // Necessary method for NSCoding
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    
    // Initialise a Checklist item properties (for the checklist categories)
    init(name: String) {
        self.name = name
        super.init()
    }
    
    // Necessary method for NSCoding - load and save the Checklist's Name and Item properties
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
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
