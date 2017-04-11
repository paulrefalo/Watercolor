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
 // MARK: - IBOutlets
    @IBOutlet var PigmentImageView: UIImageView!
    @IBOutlet var PigmentImageView1: UIImageView!
    @IBOutlet var PigmentImageView2: UIImageView!
    @IBOutlet var PigmentImageView3: UIImageView!
    @IBOutlet var PigmentImageView4: UIImageView!
    @IBOutlet var PigmentImageView5: UIImageView!
    @IBOutlet var PigmentImageView6: UIImageView!
    @IBOutlet var PigmentImageView7: UIImageView!

    @IBOutlet var PigmentNameLabel: UILabel!
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

        PigmentNameLabel.text = currentPigment.pigment_name;
        ChemicalNameLabel.text = currentPigment.chemical_name;
        ChemicalStructureLabel.text = currentPigment.chemical_formula;
        PropertiesLabel.text = currentPigment.properties;
        PermanenceLabel.text = currentPigment.permanence;
        ToxicityLabel.text = currentPigment.toxicity;
        HistoryLabel.text = currentPigment.history;
        AltNamesLabel.text = currentPigment.alternative_names;

        guard let pigmentImageName = currentPigment.image_name  else { return}

        PigmentImageView.image = UIImage(named: pigmentImageName)
        PigmentImageView2.image = UIImage(named: pigmentImageName)
        PigmentImageView2.image = UIImage(named: pigmentImageName)
        PigmentImageView3.image = UIImage(named: pigmentImageName)
        PigmentImageView4.image = UIImage(named: pigmentImageName)
        PigmentImageView5.image = UIImage(named: pigmentImageName)
        PigmentImageView6.image = UIImage(named: pigmentImageName)
        PigmentImageView7.image = UIImage(named: pigmentImageName)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }


}
