//
//  PigmentInfoTVC.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData

class PigmentInfoTVC: UITableViewController {

    // MARK: - Properties

    var currentPigment: Pigment!
    let estimatedCellHeight: CGFloat = 150
    var paints:[Paint] = []

    // MARK: - IBOutlets

    @IBOutlet var pigmentImageView: UIImageView!
    @IBOutlet var pigmentTypeLabel: UILabel!
    @IBOutlet var chemicalNameLabel: UILabel!
    @IBOutlet var chemicalStructureLabel: UILabel!
    @IBOutlet var propertiesLabel: UILabel!
    @IBOutlet var permanenceLabel: UILabel!
    @IBOutlet var toxicityLabel: UILabel!
    @IBOutlet var historyLabel: UILabel!
    @IBOutlet var altNamesLabel: UILabel!
    @IBOutlet var pigmentTitleLabel: UILabel!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = estimatedCellHeight;

        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {


        self.title = currentPigment.pigment_code
        pigmentTitleLabel.text = currentPigment.pigment_words

        chemicalNameLabel.text = currentPigment.chemical_name
        chemicalStructureLabel.text = currentPigment.chemical_formula
        propertiesLabel.text = currentPigment.properties
        permanenceLabel.text = currentPigment.permanence
        toxicityLabel.text = currentPigment.toxicity
        historyLabel.text = currentPigment.history

        // get paint names
        paints = currentPigment.used_in?.allObjects as! [Paint]

        for paint in paints {
            let theName = paint.paint_name

            if altNamesLabel.text == "None" {
                altNamesLabel.text = theName
            } else {
                altNamesLabel.text = altNamesLabel.text! + ", " + theName!
            }
        }

        guard let pigmentImageName = currentPigment.image_name  else { return}

        pigmentImageView.image = UIImage(named: pigmentImageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.layoutIfNeeded()

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        // first section is fixed, others are dynamic
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 140
            }
        }
        
        return UITableViewAutomaticDimension
    }
}
