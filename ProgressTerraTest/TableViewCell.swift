//
//  TableViewCell.swift
//  ProgressTerraTest
//
//  Created by Maria Paderina on 9/21/19.
//  Copyright © 2019 Maria Paderina. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var img: UIImageView!
    @IBOutlet var priceBLabel: UILabel!
    @IBOutlet var priceCLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
