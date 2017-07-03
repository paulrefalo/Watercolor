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
        

        ChemicalNameLabel.text = currentPigment.chemical_name
        ChemicalStructureLabel.text = currentPigment.chemical_formula
        PropertiesLabel.text = currentPigment.properties
        PermanenceLabel.text = currentPigment.permanence
        ToxicityLabel.text = currentPigment.toxicity
        HistoryLabel.text = currentPigment.history
        AltNamesLabel.text = currentPigment.alternative_names
        
        guard let pigmentImageName = currentPigment.image_name  else { return}
        
        PigmentImageView.image = UIImage(named: pigmentImageName)
        self.title = currentPigment.pigment_name


        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = estimatedCellHeight;

        tableView.delegate = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0}

        return 35
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        // first section is fixed, others are dynamic
        if (indexPath.section == 0) {
            if indexPath.row == 0 {
                return 50
            } else {
                return 80
            }
        }

        return UITableViewAutomaticDimension
    }
}
