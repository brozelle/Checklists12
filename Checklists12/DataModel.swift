//
//  DataModel.swift
//  Checklists12
//
//  Created by Buck Rozelle on 12/14/20.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.setValue(false, forKey: "FirstTime")
        }
    }
    
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
    func saveChecklists()  {
        // create an instance of property encoder
        let encoder = PropertyListEncoder()
        // sets up a block of code to catch Swift errors
        do {
            // try key word cuts out error
            let data = try encoder.encode(lists)
            // if this is successful then the data will be written to a file
            try data.write(to: dataFilePath(),
                           options: Data.WritingOptions.atomic)
            // executed if there is an error in the method
        } catch {
            // prints the error message
            print("Error encoding items arry: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        //results of dataFilePath() go into a constant
        let path = dataFilePath()
        //try to load the contents into a new data object
        if let data = try? Data(contentsOf: path)
        {
            //when checklist.plist file is found entire contents is loaded
            let decoder = PropertyListDecoder()
            do {
                //load the saved items back into items
                lists = try decoder.decode([Checklist].self,
                                           from: data)
            } catch {
                print("Error decoding item arry: \(error.localizedDescription)")
            }
        }
    }
    //MARK:- User Defaults
    
    //Set the default value
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    
    
    
}
