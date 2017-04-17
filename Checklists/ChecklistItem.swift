//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Owen Duignan on 13/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    
    // Variables
    var text = ""
    var checked = false
    
    
    // Checkmark on / off
    func toggleChecked() {
        checked = !checked
    }
}
