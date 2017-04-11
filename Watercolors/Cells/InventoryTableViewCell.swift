//
//  InventoryTableViewCell.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {

    @IBOutlet var swatchImageView: UIImageView!
    @IBOutlet var haveImageView: UIImageView!
    @IBOutlet var needImageView: UIImageView!
    @IBOutlet var nameLabelOutlet: UILabel!




    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
