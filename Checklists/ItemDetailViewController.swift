//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Owen Duignan on 13/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    // Stops the cell being highlighed when touched outside of the text field
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // Allows keyboard to automatically appear once the screen opens
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // Load the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    // Enabling / disable the Done Bar Button item depending on text being present
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        // Shortcut version of "if-else" statement (because of the > returning true or false)
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
    
    // Update Due Date Label
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    // Display the date picker scroller
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    // Below method not normally used because the table view is being used with static cells
    // and thus does not have a data source. *Note* - ensure not to interfere with inner
    // workings of the static cells with this method.
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    // Overriding the tableView numberOfRowsInSection method
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    // Providing the tableView heightForRowAt method
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // Below method calls showDatePicker() when the index-path
    // indicates that the Due Date row was tapped
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    // With this method, you trick the data source into believing that there really are 3 rows
    // in the section when the date picker is visible. The standard data source doesn't know anything
    // about the cell at row 2 in section 1 (i.e. the one with the date picker) because that cell isn't
    // part of the table view's design in the storyboard.
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    // Method to hide the date picker cell
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // Method to hide the date picker when the user taps inside the text field to show the keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }

    
    // Cancel the screen
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    // Confirm input with Done button
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        }else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // Method to update the Due Date label
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in /* Do Nothing */
            }
        }
    }
    
    
}
















