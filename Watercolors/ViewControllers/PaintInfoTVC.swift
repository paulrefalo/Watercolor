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

            let cell = tableView.dequeueReusableCell(withIdentifier: "PigmentCell", for: indexPath) as! SearchPigmentTableViewCell
            let thisPigment = pigments[indexPath.row]
          // cell.swatchImageView.image = UIImage(named: thisPigment.image_name ?? "")
         //   cell.nameLabelOutlet.text = thisPigment.pigment_words
     //       cell.pigmentOutlet.text = thisPigment.pigment_code
     //       cell.pigmentOutlet.text = thisPigment.pigment_words

            return cell

        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaintCell", for: indexPath) as! PaintTableViewCell
            cell.paintLabel.text = currentPaint.paint_history
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherNamesCell", for: indexPath) as! OtherNamesTableViewCell
            cell.otherNameLabel.text = currentPaint.other_names
            return cell
        }

    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

        } else {
            currentPaint.have = false
            haveImage.image = UIImage(named: "Have-Not")

        }
        try!managedContext.save()
    }

    @IBAction func needSwitched(_ sender: Any) {

        if needSwitch.isOn {
            currentPaint.need = true
            needImage.image = UIImage(named: "Need")

        } else {
            currentPaint.need = false
            needImage.image = UIImage(named: "Need-Not")

        }
        try!managedContext.save()
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
