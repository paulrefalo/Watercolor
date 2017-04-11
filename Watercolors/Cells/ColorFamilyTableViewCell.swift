//
//  ColorFamilyTableViewCell.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/11/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit

class ColorFamilyTableViewCell: UITableViewCell {

    @IBOutlet var swatchImageView: UIImageView!
    @IBOutlet var nameLabelOutlet: UILabel!
    @IBOutlet var lightFastOutlet: UILabel!
    @IBOutlet var transparentOutlet: UILabel!
    @IBOutlet var haveImageView: UIImageView!
    @IBOutlet var needImageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
