//
//  SearchPaintTVC.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData

class SearchPaintTVC: UITableViewController {

    // MARK: - Properties
    fileprivate let cellIdentifier = "SearchForPaintCell"
var managedContext: NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController<Paint>!
    var selectedPaint:Paint?
    var searchString:String = ""
    var loadedPaint:[Paint]?



 // MARK: - IBOutlets
    @IBOutlet var searchBar: UISearchBar!

      // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SearchPaintTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self

        let fetchRequest: NSFetchRequest<Paint> = Paint.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(Paint.paint_name), ascending: true)

        fetchRequest.sortDescriptors = [nameSort]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }


      print("afterfetch")

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...

        return cell
    }




    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
    // MARK: - UITableViewDelegate
    extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    //   let selectedPaint = fetchedResultsController.object(at: indexPath)
        
    }
}

        // MARK: - NSFetchedResultsControllerDelegate
        extension ViewController: NSFetchedResultsControllerDelegate {

            func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
               // tableView
            }
        }




