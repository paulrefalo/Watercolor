//
//  SearchPigmentTableViewCell.swift
//  Watercolors
//
//  Created by Leisa Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit

class SearchPigmentTableViewCell: UITableViewCell {

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
