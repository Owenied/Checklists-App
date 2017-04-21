//
//  DataModel.swift
//  Checklists
//
//  Created by Owen Duignan on 19/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // Obtain document directory for loading and saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        
        return paths[0]
    }
    
    // Obtain data file path for loading and saving
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // Ability to save
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        archiver.encode(lists, forKey: "Checklists")
        
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    // Ability to load
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }
    
    // Set default values
    func registerDefaults() {
        let dictionary: [String: Any] = [ "ChecklistIndex": -1, "FirstTime": true ]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // Function to handle first time usage display of the app
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    // Function to sort the checklists
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending } )
    }

}








































