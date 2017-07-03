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
    let estimatedCellHeight: CGFloat = 50
    var paints:[Paint] = []


    // MARK: - IBOutlets

    @IBOutlet var PigmentImageView: UIImageView!

    @IBOutlet var PigmentTypeLabel: UILabel!
    @IBOutlet var ChemicalNameLabel: UILabel!
    @IBOutlet var ChemicalStructureLabel: UILabel!
    @IBOutlet var PropertiesLabel: UILabel!
    @IBOutlet var PermanenceLabel: UILabel!
    @IBOutlet var ToxicityLabel: UILabel!
    @IBOutlet var HistoryLabel: UILabel!
    @IBOutlet var AltNamesLabel: UILabel!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = estimatedCellHeight;

        tableView.delegate = self

        self.title = currentPigment.pigment_name

        ChemicalNameLabel.text = currentPigment.chemical_name
        ChemicalStructureLabel.text = currentPigment.chemical_formula
        PropertiesLabel.text = currentPigment.properties
        PermanenceLabel.text = currentPigment.permanence
        ToxicityLabel.text = currentPigment.toxicity
        HistoryLabel.text = currentPigment.history


        //TODO: better way to get names???
        paints = currentPigment.used_in?.allObjects as! [Paint]


        for paint in paints {
            let theName = paint.paint_name

            if AltNamesLabel.text == "None" {
                AltNamesLabel.text = theName
            } else {
                AltNamesLabel.text = AltNamesLabel.text! + ", " + theName!
            }
        }

        guard let pigmentImageName = currentPigment.image_name  else { return}

        PigmentImageView.image = UIImage(named: pigmentImageName)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        // first section is fixed, others are dynamic
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else if indexPath.row == 1 {
                return 100
            }
        }
        
        return UITableViewAutomaticDimension
    }
}
