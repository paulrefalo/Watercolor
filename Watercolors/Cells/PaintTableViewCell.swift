//
//  PaintTableViewCell.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/11/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit

class PaintTableViewCell: UITableViewCell {

    @IBOutlet var paintLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
