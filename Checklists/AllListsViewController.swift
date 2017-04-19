//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Owen Duignan on 17/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    // Create the Checklist Category objects array
    var lists: [Checklist]
    
    // Initialise the Checklist Category objects
    required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        
        super.init(coder: aDecoder)
        
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Returns the total number of Checklist Categories
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    // Display the Checklist Category cells on screen
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for: tableView)
        let checklist = lists[indexPath.row]
        
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // Create a segue for each Checklist Category
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    // Allow a user to delete a checklist
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    // Creates the cells for the Checklist Categories to be displayed on the screen
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default,
                                   reuseIdentifier: cellIdentifier)
        }
    }
    
    // This function gives the Checklist object to the ChecklistViewController
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    // Cancel button
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Done button for adding a checklist
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist) {
        let newRowIndex = lists.count
        lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
        // Done button for editing a checklist
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist) {
        if let index = lists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        dismiss(animated: true, completion: nil)
    }
 
}
































