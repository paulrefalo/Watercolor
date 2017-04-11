//
//  SearchPigmentTCV.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData

class SearchPigmentTCV: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
var managedContext: NSManagedObjectContext!
var fetchedResultsController : NSFetchedResultsController<Pigment>!
var searchString:String = ""
 // MARK: - IBOutlets
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Pigment>(entityName: "Pigment")
        let pigmentSort = NSSortDescriptor(key: "pigment_name", ascending: true)
        request.sortDescriptors = [pigmentSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
      // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.initializeFetchedResultsController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchForPigmentCell", for: indexPath) as! SearchPigmentTableViewCell

        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }

        let this_pigment = object as Pigment
        cell.swatchImageView.image = UIImage(named: this_pigment.image_name ?? "")
        cell.nameLabelOutlet.text = this_pigment.pigment_words
        cell.pigmentOutlet.text = this_pigment.pigment_code
        cell.chemicalNameOutlet.text = this_pigment.chemical_name


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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        print("prepareForSeque to DetailView")


        if let indexPath = self.tableView.indexPathForSelectedRow {

            let dvc: PigmentInfoTVC? = (segue.destination as? PigmentInfoTVC)

            guard let object = self.fetchedResultsController?.object(at: indexPath) else {
                fatalError("No managed object")
            }

            let this_pigment = object as Pigment
            dvc?.currentPigment = this_pigment
        }


    }


}
