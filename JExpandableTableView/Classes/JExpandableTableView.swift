//
//  JExpandableTableView.swift
//  SmartCardia
//
//  Created by Pramod Jadhav on 10/04/17.
//  Copyright © 2017 Pramod Jadhav. All rights reserved.
//

import UIKit

class SectionInfo: NSObject {
    
    var isOpen: Bool!
    var noOfRows: Int = 0
}

protocol JTableHeaderViewDelegate : NSObjectProtocol{
    
    func headerView(sectionOpened: JExpandableTableViewHV,section : Int)
    func headerView(sectionClosed: JExpandableTableViewHV,section : Int)
}

open class JExpandableTableViewHV: UITableViewHeaderFooterView {
    
    var sectionInfo : SectionInfo!
    var section : Int!
    weak var delegate : JTableHeaderViewDelegate?
    var tapGesture : UITapGestureRecognizer?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.headerTapped(_:)))
        self.addGestureRecognizer(tapGesture!)
    }
    
    override open func awakeFromNib() {
        commonInit()
    }
    
    func headerTapped(_ sender: UITapGestureRecognizer) {
        
        self.sectionInfo.isOpen = !self.sectionInfo.isOpen
        if self.sectionInfo.isOpen == true {
            self.delegate?.headerView(sectionOpened: self, section: self.section)
        }else{
            self.delegate?.headerView(sectionClosed: self, section: self.section)
        }
    }
    
    open  func uiSetupForClosedState() {
    }
    
    open  func uiSetupForExpandedState() {
    }
}

public protocol JExpandableTableViewDataSource : NSObjectProtocol {
    
    func tableView(_ tableView: JExpandableTableView, numberOfRowsInSection section: Int, callback : @escaping (_ noOfRows: Int)->Void) -> Void
    
    func tableView(_ tableView: JExpandableTableView, initialNumberOfRowsInSection section: Int) -> Int
    
    func tableView(_ tableView: JExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    func numberOfSections(in tableView: JExpandableTableView) -> Int //
}

//Extended just to make it optional in JExpandableTableViewDataSource protocol
public extension JExpandableTableViewDataSource{
    
    func tableView(_ tableView: JExpandableTableView, initialNumberOfRowsInSection section: Int) -> Int{
        return 0
    }
}

public protocol JExpandableTableViewDelegate : NSObjectProtocol {
    
    func tableView(_ tableView: JExpandableTableView, viewForHeaderInSection section: Int) -> UIView? // custom view for header. will be adjusted to default or specified header height
    
    func tableView(_ tableView: JExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat // custom view for header. will be adjusted to default or specified header height
    
    func tableView(_ tableView: JExpandableTableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    
    func tableView(_ tableView: JExpandableTableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    
    func tableView(_ tableView: JExpandableTableView, headerView: JExpandableTableViewHV,didExpandSection section: Int) -> Void
    
    func tableView(_ tableView: JExpandableTableView, headerView: JExpandableTableViewHV, didCloseSection section: Int) -> Void
    
    func tableView(_ tableView: JExpandableTableView, didSelectRowAt indexPath: IndexPath)
}

//Extended just to make it optional in JExpandableTableViewDataSource protocol
public extension JExpandableTableViewDelegate{
    
    func tableView(_ tableView: JExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 44
    }
    
    func tableView(_ tableView: JExpandableTableView, headerView: JExpandableTableViewHV,didExpandSection section: Int) -> Void{
        
    }
    
    func tableView(_ tableView: JExpandableTableView, headerView: JExpandableTableViewHV, didCloseSection section: Int) -> Void{
        
    }
    
    func tableView(_ tableView: JExpandableTableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func tableView(_ tableView: JExpandableTableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: JExpandableTableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
}

@IBDesignable
public class JExpandableTableView: UIView , UITableViewDataSource, UITableViewDelegate, JTableHeaderViewDelegate{
    
    //config
    public var keepPreviousCellExpanded: Bool = false
    
    var tableview: UITableView!
    var lastSectionInfo: SectionInfo!
    var lastOpenSectionIndex: Int = NSNotFound
    
    weak public var dataSource: JExpandableTableViewDataSource?
    weak public var delegate: JExpandableTableViewDelegate?
    var sectionInfoArray  = [SectionInfo]()
    
    // JExpandableTableView Public method
    public func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell{
        
        return self.tableview.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    public func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView? {
        return self.tableview.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }
    
    public func register(_ nib: UINib?, forCellReuseIdentifier identifier: String){
        
        self.tableview!.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String){
        
        self.tableview!.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func setEstimatedRowHeight(height : CGFloat) -> Void {
        tableview.estimatedRowHeight = height
    }
    
    public func setRowHeight(height : CGFloat) -> Void {
        tableview.rowHeight = height
    }
    
    public func reloadData() -> Void {
        
        sectionInfoArray.removeAll()
        self.lastOpenSectionIndex = NSNotFound
        self.tableview.reloadData()
    }
    
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation){
        self.tableview.reloadRows(at: indexPaths, with: animation)
    }
    
    
    /**
     Adds refresh control at top of table view for pull to refresh intercations
     
     @param refreshControl - UIRefreshControl object
     
     */
    public func addRefreshControler(refreshControl : UIRefreshControl){
        
        tableview.addSubview(refreshControl)
    }
    
    @IBInspectable public var disableCellSeparator:Bool  = false{
        
        didSet{
            
            if disableCellSeparator {
                tableview.separatorStyle = .none
            }else{
                tableview.separatorStyle = .singleLine
            }
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        if disableCellSeparator {
            tableview.separatorStyle = .none
        }else{
            tableview.separatorStyle = .singleLine
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        
        sectionInfoArray = [SectionInfo]()
        tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        #if !TARGET_INTERFACE_BUILDER
            // this code will run in the app itself
            tableview.delegate = self
            tableview.dataSource = self
            
        #else
            // this code will execute only in IB
        #endif
        
        addSubview(tableview!)
        
        self.addConstraints([
            NSLayoutConstraint(item: tableview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableview, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableview, attribute: .trailing, relatedBy: .equal, toItem: self,  attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        
    }
    
    //TableView delegate methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let sectionInfo = self.sectionInfoArray[section]
        if sectionInfo.isOpen != true{
            return 0
        }else{
            
            return sectionInfo.noOfRows
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        return self.dataSource!.tableView(self, cellForRowAt :indexPath)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        let sections = self.dataSource!.numberOfSections(in : self);
        if sectionInfoArray.count == 0  {
            
            for section in 0 ..< sections {
                
                let initialNoOfCells =  self.dataSource!.tableView(self, initialNumberOfRowsInSection: section)
                
                let info = SectionInfo()
                if initialNoOfCells > 0{
                    info.isOpen = true
                }else{
                    info.isOpen = false
                }
                info.noOfRows = initialNoOfCells
                sectionInfoArray.append(info)
            }
        }
        
        return sections
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let headerView: JExpandableTableViewHV = (self.delegate!.tableView(self,viewForHeaderInSection:section) as? JExpandableTableViewHV)!
        let info = self.sectionInfoArray[section]
        headerView.section = section
        headerView.sectionInfo = info
        if info.isOpen != true {
            headerView.uiSetupForClosedState()
        }else{
            headerView.uiSetupForExpandedState()
        }
        headerView.delegate = self
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (self.delegate?.tableView(self, heightForHeaderInSection: section))!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (self.delegate?.tableView(self, heightForRowAtIndexPath: indexPath))!
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.delegate?.tableView(self, estimatedHeightForRowAt: indexPath))!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.tableView(self, didSelectRowAt: indexPath)
    }
    
    public func closeHeader(section : Int){
    
        let headerView:JExpandableTableViewHV  =  self.tableview.headerView(forSection: section) as! JExpandableTableViewHV;
        closeHeader(headerView: headerView, section: section)
    }
    
    public func openHeader(section : Int){
        
        let headerView:JExpandableTableViewHV  =  self.tableview.headerView(forSection: section) as! JExpandableTableViewHV;
        openHeader(headerView: headerView, section: section)
    }

    
    private func closeHeader(headerView:JExpandableTableViewHV,section : Int){
        
        if(headerView.sectionInfo.isOpen == false){
            
            let sectionClosed = headerView
            let noOfRows  = self.tableview.numberOfRows(inSection: section)
            var array = [IndexPath]()
            for index in  0..<noOfRows{
                
                let indexPath = IndexPath(row: index, section: section)
                array.append(indexPath)
                
            }
            self.tableview.beginUpdates()
            if array.count != 0 {
                self.tableview.deleteRows(at: array, with: .automatic)
            }
            self.tableview.endUpdates()
            self.delegate?.tableView(self, headerView: sectionClosed, didCloseSection: section)
            sectionClosed.uiSetupForClosedState()
            self.lastOpenSectionIndex = NSNotFound
        }
    }
    
    
    private func openHeader(headerView:JExpandableTableViewHV,section : Int){
        
        if(headerView.sectionInfo.isOpen == true){
            
            let sectionOpened = headerView

            self.tableview.beginUpdates()
            let alastOpenSectionIndex = self.lastOpenSectionIndex
            let currentSection = section
            self.lastOpenSectionIndex = currentSection
            
            self.dataSource?.tableView(self, numberOfRowsInSection: section, callback: { (noOfRows : Int) in
                
                let info : SectionInfo = self.sectionInfoArray[section]
                info.noOfRows = noOfRows
                
                var array = [IndexPath]()
                for index in  0..<noOfRows{
                    
                    let indexPath = IndexPath(row: index, section: currentSection)
                    array.append(indexPath)
                    
                }
                
                if alastOpenSectionIndex != NSNotFound && self.keepPreviousCellExpanded == false{
                    
                    let info : SectionInfo = self.sectionInfoArray[alastOpenSectionIndex]
                    info.isOpen = false
                    let rows = self.tableview.numberOfRows(inSection: alastOpenSectionIndex)
                    var rowsToDelete = [IndexPath]()
                    for index in  0..<rows{
                        
                        let indexPath = IndexPath(row: index, section: alastOpenSectionIndex)
                        rowsToDelete.append(indexPath)
                        
                    }
                    
                    if rowsToDelete.count != 0 {
                        self.tableview.deleteRows(at: rowsToDelete, with: .automatic)
                    }
                }
                if array.count != 0{
                    self.tableview.insertRows(at: array, with: .automatic)
                }
                self.tableview.endUpdates()
                self.delegate?.tableView(self, headerView: sectionOpened, didExpandSection: section)
                sectionOpened.uiSetupForExpandedState()
            })
        }
    }
    
    //JExpandableTableViewHV
    func headerView(sectionOpened: JExpandableTableViewHV,section : Int){
        
        openHeader(headerView: sectionOpened, section: section)
    }
    
    func headerView(sectionClosed: JExpandableTableViewHV,section : Int){
        
        closeHeader(headerView: sectionClosed, section: section)

    }
    
}
