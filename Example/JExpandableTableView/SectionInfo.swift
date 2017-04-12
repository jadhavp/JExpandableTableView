//
//  SectionInfo.swift
//  JExpandableTableView
//
//  Created by Pramod Jadhav on 11/04/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class SectionInfo: NSObject {

    var cells = [CellInfo]()
    var title: String
    
    init(_ text: String) {
        
        self.title = text
    }
}
