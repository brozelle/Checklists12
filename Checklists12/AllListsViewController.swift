//
//  AllListsViewController.swift
//  Checklists12
//
//  Created by Buck Rozelle on 12/13/20.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellIdentifier)
        
        print("Documents folder is \(dataModel.documentsDirectory())")
        print("Data file path is \(dataModel.dataFilePath())")
        
        // Add placeholder data
        /*  var list = Checklist(name: "Birthdays")
        dataModel.lists.append(list)

          list = Checklist(name: "Groceries")
        dataModel.lists.append(list)

          list = Checklist(name: "Cool Apps")
        dataModel.lists.append(list)

          list = Checklist(name: "To Do")
        dataModel.lists.append(list)
        
        for list in dataModel.lists {
            let item = ChecklistItem()
            item.text = "Item for \(list.name)"
            list.items.append(item)
        }*/

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        //let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist",
                          sender: checklist)
        }
    }
    
    //tap the row, perform the seque
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        //UserDefaults.standard.setValue(indexPath.row, forKey: "ChecklistIndex")
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist",
                     sender: checklist)
    }
    
   
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist"
        {
            let contrller = segue.destination as! ListDetailViewController
            contrller.delegate = self
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)

        cell.textLabel!.text = "List \(indexPath.row)"
        
        // Update cell information
        let checklist = dataModel.lists[indexPath.row]
          cell.textLabel!.text = checklist.name
          cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
    //MARK:- Navigation Controller Delegates
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        //Was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    // MARK: - View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    {
      navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist)
    {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)

      let indexPath = IndexPath(row: newRowIndex,
                                section: 0)
        
        let indexPaths = [indexPath]
      
        tableView.insertRows(at: indexPaths,
                           with: .automatic)

      navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist)
    {
        if let index = dataModel.lists.firstIndex(of: checklist) {
        let indexPath = IndexPath(row: index,
                                  section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) {
          cell.textLabel!.text = checklist.name
        }
      }
      navigationController?.popViewController(animated: true)
    }

    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
      
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths,
                             with: .automatic)
    }
    
    //Enables editing
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
      let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
      controller.delegate = self

        let checklist = dataModel.lists[indexPath.row]
      controller.checklistToEdit = checklist

      navigationController?.pushViewController(controller,
                                               animated: true)
        
    }

}
