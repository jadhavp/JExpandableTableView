//
//  ViewController.swift
//  JExpandableTableView
//
//  Created by Pramod Jadhav on 04/11/2017.
//  Copyright (c) 2017 Pramod Jadhav. All rights reserved.
//

import UIKit
import JExpandableTableView
import SVProgressHUD

class ViewController: UIViewController,JExpandableTableViewDataSource, JExpandableTableViewDelegate {
    
    var dataArray = [SectionInfo]()
    @IBOutlet weak var jtableView: JExpandableTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Book details"
        
        jtableView = JExpandableTableView(frame: <#T##CGRect#>)

        jtableView.delegate = self
        jtableView.dataSource = self
        jtableView.keepPreviousCellExpanded = true
        
        var cellInfo = CellInfo("Game of thrones",cellId: "TextCell")
        let sec1 = SectionInfo("Name")
        sec1.cells.append(cellInfo)
        
        let sec2 = SectionInfo("Description")
        cellInfo = CellInfo("Lorem, Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",cellId: "TextCell")
        sec2.cells.append(cellInfo)

        let sec3 = SectionInfo("Chapters")
        cellInfo = CellInfo("",cellId: "TextCell")
        
        let sec4 = SectionInfo("Image")
        cellInfo = CellInfo("",cellId: "ImageCell")
        sec4.cells.append(cellInfo)

        dataArray.append(sec1)
        dataArray.append(sec2)
        dataArray.append(sec3)
        dataArray.append(sec4)

        var celNib = UINib.init(nibName: "ImageCell", bundle: nil)
        jtableView.register(celNib, forCellReuseIdentifier: "ImageCell")
        celNib = UINib.init(nibName: "TextCell", bundle: nil)
        jtableView.register(celNib, forCellReuseIdentifier: "TextCell")

        let headerNib = UINib.init(nibName: "HeaderView", bundle: nil)
        jtableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: JExpandableTableView, numberOfRowsInSection section: Int, callback:  @escaping (Int) -> Void) {

        let sectionInfo = self.dataArray[section]
        if sectionInfo.cells.count != 0 {
            callback(sectionInfo.cells.count)
        }else{
            
            tableView.isUserInteractionEnabled = false
            SVProgressHUD.show(withStatus: "Loading chapters...")
            
            DispatchQueue.global().async {
                
                Thread.sleep(forTimeInterval: 2)
                DispatchQueue.main.sync {
                    tableView.isUserInteractionEnabled = true
                    SVProgressHUD.dismiss()
                    let sectionInfo = self.dataArray[section]
                    sectionInfo.cells.append(CellInfo("1. Prologue ",cellId: "TextCell"))
                    sectionInfo.cells.append(CellInfo("2. Bran I",cellId: "TextCell"))
                    sectionInfo.cells.append(CellInfo("3. Catelyn I",cellId: "TextCell"))
                    sectionInfo.cells.append(CellInfo("4. Daenerys I",cellId: "TextCell"))
                    sectionInfo.cells.append(CellInfo("5.  A Game of Thrones, very very long chapter beyond the wall",cellId: "TextCell"))
                    
                    callback(sectionInfo.cells.count)
                }
            }
        }
    }
    
    func tableView(_ tableView: JExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let section = self.dataArray[indexPath.section]
        let row = section.cells[indexPath.row]

        let cellId = row.cellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId!, for: indexPath)
    
        cell.contentView.backgroundColor = UIColor.white
        let label = cell.viewWithTag(11) as? UILabel
        label?.text = row.text
        return cell
    }
    
    func numberOfSections(in tableView: JExpandableTableView) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: JExpandableTableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let section = self.dataArray[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        header?.contentView.backgroundColor = UIColor.groupTableViewBackground
        let label = header?.viewWithTag(11) as? UILabel
        label?.text = section.title
        return header
    }
    
    // Needed only if you want to show cells expanded on first load, JExpandableTableView will show cells expanded if this method returns number of cells greater than zero and current section have cells more than zero
    func tableView(_ tableView: JExpandableTableView, initialNumberOfRowsInSection section: Int) -> Int{
        
        if section == 0  {
            let section = self.dataArray[section]
            return section.cells.count
        }else{
            return 0
        }
    }

}
