//
//  Checklist.swift
//  Checklists
//
//  Created by Owen Duignan on 18/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    var name = ""
    
    // Initialise a Checklist item properties (for the checklist categories)
    init(name: String) {
        self.name = name
        super.init()
    }
}
