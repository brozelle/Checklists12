//
//  ItemDetailViewController.swift
//  Checklists12
//
//  Created by Buck Rozelle on 12/8/20.
//

import UIKit
import UserNotifications

//Mark:- Delegate Protocol
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem)
    
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
        doneBarButton.isEnabled = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // Mark:- Outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet var shouldRemindSwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    // Mark:- Actions
    @IBAction func cancel() {
        
        //Sends the message back to the delegate.
        delegate?.itemDetailViewControllerDidCancel(self)
        
    }
    
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
        
        print("Contents of the text field: \(textField.text!)")

    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
      
        textField.resignFirstResponder()

      if switchControl.isOn {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {_, _ in
          // do nothing
        }
      }
    }

    
    // Mark:- Table View Delegates
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    
    }
    
    // MARK: - Text Field Delegates
    // Disallowing empty input
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
      
        let oldText = textField.text!
        let stringRange = Range(range,
                                in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    
    //handling the clear button
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
