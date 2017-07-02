//
//  PigmentTableViewCell.swift
//  Watercolors
//
//  Created by Paul Refalo on 7/2/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit

class PigmentTableViewCell: UITableViewCell {

    @IBOutlet var swatchImageView: UIImageView!
    @IBOutlet var nameLabelOutlet: UILabel!
    @IBOutlet var pigmentOutlet: UILabel!
    @IBOutlet var chemicalNameOutlet: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
