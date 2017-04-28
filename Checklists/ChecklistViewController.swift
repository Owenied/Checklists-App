//
//  ViewController.swift
//  Checklists
//
//  Created by Owen Duignan on 12/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of rows in the app based on the size of the storage array
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    // Adding the cells c/w text and checkmark to the view
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureCheckmark(for: cell, with: item)
        configureText(for: cell, with: item)
        return cell
    }
    
    // When a row is tapped by the user
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        // Stops cells from remaining highlighted when tapped i.e. the cell will highlight then revert
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Deleting a row
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths,
                             with: .automatic)
    }
    
    // Checkmark selection on / off
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
        
        label.textColor = view.tintColor
    }
    
    // Configure text function
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = item.text
    }
    
    // ItemDetailViewControllerDegegate Protocol methods to cancel
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // ItemDetailViewControllerDegegate Protocol methods to save new user "to-do" item
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    // Segue into the Add Item screen
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // Edit and save a To Do item
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
}







































