//
//  PaintInfoTVC.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData
class PaintInfoTVC: UITableViewController {

    // MARK: - Properties

    var currentPaint: Paint!
    var pigments:[Pigment] = []
    var managedContext: NSManagedObjectContext!

    // Cell Identifiers

    let pigementCellIdentifier = "PigmentCell"
    let paintCellIdentifier = "PaintCell"
    let otherNamesCellIdentifier = "OtherNamesCell"

    let estimatedCellHeight: CGFloat = 80


    // MARK: - IBOutlets

    @IBOutlet var paintSwatchImage: UIImageView!
    @IBOutlet var haveImage: UIImageView!
    @IBOutlet var needImage: UIImageView!

    @IBOutlet var paintNameLabel: UILabel!
    @IBOutlet var lightfastLabel: UILabel!
    @IBOutlet var opacityLabel: UILabel!
    @IBOutlet var stainingLabel: UILabel!

    @IBOutlet var haveSwitch: UISwitch!
    @IBOutlet var needSwitch: UISwitch!


    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.coreDataStack.managedContext

        // setup the view portion of the screen
        let paintImageName = String(currentPaint.paint_number)
        paintSwatchImage.image = UIImage(named: paintImageName)

        paintNameLabel.text = currentPaint.paint_name
        lightfastLabel.text = currentPaint.lightfast_rating
        opacityLabel.text = currentPaint.opacity
        stainingLabel.text = currentPaint.staining_granulating

        if currentPaint.have == true {
            haveImage.image = UIImage(named: "Have")
            haveSwitch.setOn(true, animated: false)

        } else {
            haveImage.image = UIImage(named: "Have-Not")
            haveSwitch.setOn(false, animated: false)
        }

        if currentPaint.need == true {
            needImage.image = UIImage(named: "Need")
            needSwitch.setOn(true, animated: false)

        } else {
            needImage.image = UIImage(named: "Need-Not")
            needSwitch.setOn(false, animated: false)
        }

        pigments = currentPaint.contains?.allObjects as! [Pigment]

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = estimatedCellHeight;

        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return pigments.count
        } else {
            return 1
        }

    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        if indexPath.section == 0 {


            let cell: PigmentTableViewCell = (tableView.dequeueReusableCell(withIdentifier: pigementCellIdentifier)! as? PigmentTableViewCell)!


            let thisPigment = pigments[indexPath.row]

            if let pigmentImageName = thisPigment.image_name {

                if let pigmentImage = UIImage(named: pigmentImageName) {

                    cell.swatchImageView.image = pigmentImage
                }
            }
            cell.nameLabelOutlet.text = thisPigment.pigment_words
            cell.pigmentOutlet.text = thisPigment.pigment_code
            cell.chemicalNameOutlet.text = thisPigment.chemical_name


            return cell

        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: paintCellIdentifier, for: indexPath) as! PaintTableViewCell
            let  paintHistoryText = currentPaint.paint_history
            cell.paintLabel.text = paintHistoryText
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: otherNamesCellIdentifier, for: indexPath) as! OtherNamesTableViewCell
            let otherNamesText = currentPaint.other_names
            cell.otherNameLabel.text = otherNamesText
            return cell
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 80
        }

        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pigments"
        case 1:
            return "Information"
        case 2:
            return "Other Names"
        default:
            return ""
        }
    }


    @IBAction func haveSwitched(_ sender: Any) {

        if haveSwitch.isOn {
            currentPaint.have = true
            haveImage.image = UIImage(named: "Have")
            print("Paint switched to have:  \(String(describing: currentPaint.paint_number))")
        } else {
            currentPaint.have = false
            haveImage.image = UIImage(named: "Have-Not")

        }
        do {
            if managedContext.hasChanges {
                print("ManagedContext has Changes ***********")
                try managedContext.save()
            }
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        
        
    }
    

    @IBAction func needSwitched(_ sender: Any) {

        if needSwitch.isOn {
            currentPaint.need = true
            needImage.image = UIImage(named: "Need")

        } else {
            currentPaint.need = false
            needImage.image = UIImage(named: "Need-Not")

        }
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSeque to PigmentDetail")
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            let dvc: PigmentInfoTVC? = (segue.destination as? PigmentInfoTVC)
            let this_pigment = pigments[indexPath.row]
            dvc?.currentPigment = this_pigment
        }
    }
    
    
}
