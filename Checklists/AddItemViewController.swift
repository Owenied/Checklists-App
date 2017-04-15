//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Owen Duignan on 13/04/2017.
//  Copyright © 2017 Owen Duignan. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController,
                               didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: AddItemViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    // Stops the cell being highlighed when touched outside of the text field
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // Allows keyboard to automatically appear once the screen opens
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
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
    
    // Cancel the screen
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    // Confirm input
    @IBAction func done() {
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
        
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
}
