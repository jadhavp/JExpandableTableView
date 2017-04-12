//
//  CellInfo.swift
//  JExpandableTableView
//
//  Created by Pramod Jadhav on 11/04/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CellInfo: NSObject {
    
    var text: String!
    var cellId: String!
    
    
    init(_ text: String, cellId: String) {
        
        self.text = text
        self.cellId = cellId
    }
}
