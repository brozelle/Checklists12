//
//  AllListsViewController.swift
//  Checklists12
//  The AllListViewController is the class for the All Lists Scene
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
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        print("Documents folder is \(dataModel.documentsDirectory())")
        print("Data file path is \(dataModel.dataFilePath())")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        //If there are no lists, then go right to the Checklist Scene.
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist",
                          sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Loads the data from the Checklist12.plist file.
        tableView.reloadData()
    }
    
    //Tap the row, perform the seque
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist",
                     sender: checklist)
    }
    
   
    //MARK:- Navigation
    //Specifies which View Controller to open based on the segue.
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
    //Display the number of rows in the data model array "lists."
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    //Asks for a new cell, configures it, and populates it with default info.
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: cellIdentifier)
        }
        cell.textLabel!.text = "List \(indexPath.row)"
        
        // Configure the cell.
        let checklist = dataModel.lists[indexPath.row]
          cell.textLabel!.text = checklist.name
          cell.accessoryType = .detailDisclosureButton
        
        //Configures subtitle.
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else {
        cell.detailTextLabel!.text = count == 0 ? "All Done!" : "\(count) Remaining"
        }
        //Configures image.
        cell.imageView!.image = UIImage(named: checklist.iconName)
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
   
    //For the cancel button.
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    {
      navigationController?.popViewController(animated: true)
    }

    //After the
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist)
    {
          dataModel.lists.append(checklist)
          dataModel.sortChecklists()
          tableView.reloadData()
          navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist)
    {
          dataModel.sortChecklists()
          tableView.reloadData()
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
