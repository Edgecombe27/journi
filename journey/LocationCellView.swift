//
//  LocationCellView
//  journey
//
//  Created by Spencer Edgecombe on 3/7/18.
//  Copyright © 2018 fwt. All rights reserved.
//

import UIKit

class LocationCellView: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    var menu : MenuViewController!
    @IBOutlet var cellContentView: UIView!
    var mark : Mark!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        editButton.layer.cornerRadius = 20
        editButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 20
        deleteButton.layer.masksToBounds = true
    }

    func render(withMark: Mark, andMenu: MenuViewController){
        menu = andMenu
        mark = withMark
        titleLabel.text = mark.title
        cellContentView.layer.cornerRadius = 30
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to delete \(mark.title)?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.menu.viewController.userData.deleteMark(withName: self.mark.title)
            self.menu.viewController.loadSavedMarks()
            var i = 0
            for m in self.menu.myLocations {
                if m.title == self.mark.title {
                    self.menu.myLocations.remove(at: i)
                    self.menu.tableView.reloadData()
                    break
                }
                i = i + 1
            }
        }))
        
        menu.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func editTapped(_ sender: Any) {
        menu.dismiss(animated: true, completion: {
            self.menu.viewController.editMark(withTitle: self.mark.title)
            
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
