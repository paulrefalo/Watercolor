//
//  ColorFamilyTVC.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData
class ColorFamilyTVC: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    var colorFamily: String!
    var fetchedResultsController : NSFetchedResultsController<Paint>!
     // MARK: - IBOutlets


          // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title=colorFamily
        self.initializeFetchedResultsController()

    }

    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Paint>(entityName: "Paint")
        let paintSort = NSSortDescriptor(key: "paint_name", ascending: true)
        request.sortDescriptors = [paintSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        // only select color family
        request.predicate = NSPredicate(format: "color_family CONTAINS %@", colorFamily)

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorFamilyCell", for: indexPath) as! ColorFamilyTableViewCell

        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }

        let this_paint = object as Paint
        let image_name = String(stringInterpolationSegment: this_paint.paint_number)
        cell.swatchImageView.image = UIImage(named: image_name )
        cell.nameLabelOutlet.text = this_paint.paint_name
        cell.lightFastOutlet.text = this_paint.lightfast_rating

        if this_paint.have == true {
            cell.haveImageView.image = UIImage(named: "Have")

        } else {
            cell.haveImageView.image = UIImage(named: "Have-Not")
        }

        if this_paint.need == true {
            cell.needImageView.image = UIImage(named: "Need")

        } else {
            cell.needImageView.image = UIImage(named: "Need-Not")
        }



        if let opacity = this_paint.opacity, let staining = this_paint.staining_granulating {
            let comboStr =  "\(opacity) - \(staining)"
            cell.transparentOutlet.text = comboStr
        }


        //Populate the cell from the object
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        print("prepareForSeque to PaintView")


        if let indexPath = self.tableView.indexPathForSelectedRow {

            let dvc: PaintInfoTVC? = (segue.destination as? PaintInfoTVC)

            guard let object = self.fetchedResultsController?.object(at: indexPath) else {
                fatalError("No managed object")
            }

            let selectedPaint = object as Paint
            dvc?.currentPaint = selectedPaint
        }
        
    }
}
