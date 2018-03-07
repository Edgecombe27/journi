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
    
    @IBOutlet var cellContentView: UIView!
    var mark : Mark!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func render(withMark: Mark){
        mark = withMark
        titleLabel.text = mark.title
        cellContentView.layer.cornerRadius = 30
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
