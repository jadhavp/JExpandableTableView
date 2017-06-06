# JExpandableTableView
JExpandableTableView provides out of box support for expandable table cells

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## App Preview ( Checkout [live example app](https://appetize.io/embed/pa5850fv541uff63va4dxtcjrw?device=iphone7&scale=75&orientation=portrait&osVersion=10.3): courtesy Appetize ) 
![](https://github.com/jadhavp/JExpandableTableView/blob/master/Example/preview.gif)
![](https://github.com/jadhavp/JExpandableTableView/blob/master/Example/Screen_Shot_3.png)

## Requirements
* Xcode 8.x
* Swift 3.x
* iOS 8.0

## Installation

JExpandableTableView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JExpandableTableView"
```
## Features
* Expandable cells
* Allows to fetch cells asynchronously (refer tableView(_ tableView: JExpandableTableView, numberOfRowsInSection section: Int, callback:  @escaping (Int) -> Void) method in Example)
* Multple configaration for cell expansion and collapse
* Easy integration through xib
* Highly customizable - JExpandableTableView accepts any Header view and Custom cells which makes it very customizable similar to UITableView

## Code Integration
Creating instance 
* Using interface builder, set class of any UIView to JExpandableTableView & create outlet in respective viewcontroller
```swift
    @IBOutlet weak var jtableView: JExpandableTableView!
```
* Using interface builder, set class of any UIView to JExpandableTableView & create outlet in respective viewcontroller
```swift
    jtableView = JExpandableTableView(frame: <#T##CGRect#>)
```
Assign delegates, smilar to UITableView delegate
```swift
        jtableView.delegate = self
        jtableView.dataSource = self
```
Sample delegate methods given below, please refer Example app to get more information.
```swift
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
```

### Manually open/close Headers
Below code snippet copied from sample app, which demonstrate this feature
```swift
        jtableView.openHeader(section: 1);
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            jtableView.closeHeader(section: 1);

        })
```

### Support UIRefreshControl
```swift
    jtableView.addRefreshControler(refreshControl: <UIRefreshControl>)
```

## Contributing

If anyone interested in new additions to this repo please feel free to create pull request.

## Author

Pramod Jadhav

## License

JExpandableTableView is available under the MIT license. See the LICENSE file for more info.
