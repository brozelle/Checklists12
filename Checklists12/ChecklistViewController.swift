//
//  ChecklisetViewController.swift
//  Checklists12
//
//  Created by Buck Rozelle on 12/7/20.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never

        title = checklist.name
        
        //print("Documents folder is \(documentsDirectory())")
        //print("Data file path is \(dataFilePath())")
        
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
}
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    /*// MARK:- Documents Directory
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("Checklists.plist")
        
    }
    
    // MARK:- Data file downloading/uploading
    func saveChecklistItems()  {
        // create an instance of property encoder
        let encoder = PropertyListEncoder()
        // sets up a block of code to catch Swift errors
        do {
            // try key word cuts out error
            let data = try encoder.encode(items)
            // if this is successful then the data will be written to a file
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
            // executed if there is an error in the method
        } catch {
            // prints the error message
            print("Error encoding items arry: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        //results of dataFilePath() go into a constant
        let path = dataFilePath()
        //try to load the contents into a new data object
        if let data = try? Data(contentsOf: path)
        {
            //when checklist.plist file is found entire contents is loaded
            let decoder = PropertyListDecoder()
            do {
                //load the saved items back into items
                items = try decoder.decode([ChecklistItem].self,
                                           from: data)
            } catch {
                print("Error decoding item arry: \(error.localizedDescription)")
            }
        }
    }
 */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
      
        //Give the segue a unique identifier
      if segue.identifier == "AddItem" {
        //Whatt is the view controller to be displayed
        let controller = segue.destination as! ItemDetailViewController
        //Set the delegate property
        controller.delegate = self
      
      } else if segue.identifier == "EditItem" {
        let controller = segue.destination as! ItemDetailViewController
        controller.delegate = self
        
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            controller.itemToEdit = checklist.items[indexPath.row]
        }
      }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",
                                               for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)

      return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
        item.checked.toggle()
        configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath,
                               animated: true)
        
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths,
                             with: .automatic)
    }
    
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
      
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem) {
      
        if let index = checklist.items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index,
                                  section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated: true)
        
    }
    
}

