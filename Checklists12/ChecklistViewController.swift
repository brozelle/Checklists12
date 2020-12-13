//
//  ViewController.swift
//  Checklists12
//
//  Created by Buck Rozelle on 12/7/20.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem) {
      
        if let index = items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index,
                                  section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    var items = [ChecklistItem]()
    
    // MARK:- Documents Directory
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
    
    // MARK:- Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true

       /* let item1 = ChecklistItem()
          item1.text = "Walk the dog"
          items.append(item1)

          let item2 = ChecklistItem()
          item2.text = "Brush my teeth"
          item2.checked = true
          items.append(item2)

          let item3 = ChecklistItem()
          item3.text = "Learn iOS development"
          item3.checked = true
          items.append(item3)

          let item4 = ChecklistItem()
          item4.text = "Soccer practice"
          items.append(item4)

          let item5 = ChecklistItem()
          item5.text = "Eat ice cream"
          items.append(item5)
        */
        
        loadChecklistItems()
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
        
    }
    
    func configureCheckmark(
      for cell: UITableViewCell,
        with item: ChecklistItem
    ) {

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


    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",
                                               for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        
        configureCheckmark(for: cell, with: item)

      return cell
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath) {
        
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
            
        }
        tableView.deselectRow(at: indexPath,
                               animated: true)
        
        saveChecklistItems()
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths,
                             with: .automatic)
        
        saveChecklistItems()
    }
    
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
            controller.itemToEdit = items[indexPath.row]
        }
      }
    }
}

