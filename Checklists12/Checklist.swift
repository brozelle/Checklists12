//
//  Checklist.swift
//  Checklists12
//
//  Created by Buck Rozelle on 12/13/20.
//

import UIKit

class Checklist: NSObject, Codable {
    
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }

}
