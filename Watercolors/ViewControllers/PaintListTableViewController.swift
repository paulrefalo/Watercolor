//
//  PaintListTableViewController.swift
//  Watercolors
//
//  Created by Paul Refalo on 7/2/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import FirebaseDatabase

class PaintListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate  {

    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController<Paint>!
    var searchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var searchPredicate: NSCompoundPredicate?
    var inventoryPredicate: NSPredicate?
    let ref = FIRDatabase.database().reference(withPath: "Watercolors")
    let loginManager = FBSDKLoginManager()

    // MARK: - IBOutlets

    @IBOutlet var inventorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.coreDataStack.managedContext
        self.initializeFetchedResultsController()
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if (FBSDKAccessToken.current() != nil) {
            settingsButton.title = "Logout"
        } else {
            settingsButton.title = "Login"
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchForPaintCell", for: indexPath) as! SearchPaintTableViewCell

        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        //Populate the cell from the object
        let this_paint = object as Paint
        let image_name = String(stringInterpolationSegment: this_paint.paint_number)
        cell.swatchImageView.image = UIImage(named: image_name )
        cell.nameLabelOutlet.text = this_paint.paint_name
        cell.lightFastOutlet.text = this_paint.lightfast_rating


        if (this_paint.need) {
            cell.needImageView.image = UIImage(named:"Need")
        } else {
            cell.needImageView.image = UIImage(named:"Need-Not")

        }

        if (this_paint.have) {
            cell.haveImageView.image = UIImage(named:"Have")
        } else {
            cell.haveImageView.image = UIImage(named:"Have-Not")

        }

        if let opacity = this_paint.opacity, let staining = this_paint.staining_granulating {
            let comboStr =  "\(opacity) - \(staining)"
            cell.transparentOutlet.text = comboStr
        }

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
        return 90.0
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
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

    // MARK: - coredata

    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Paint>(entityName: "Paint")
        let pigmentSort = NSSortDescriptor(key: "sort_order", ascending: true)
        request.sortDescriptors = [pigmentSort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)

        // limit table by segmented control and/or searchbar text
        if let searchPredicate  = searchPredicate {
            if let inventoryPredicate = inventoryPredicate {

                // has both segmented controll filter and search text
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, inventoryPredicate])
            } else {
                // has search text only
                request.predicate = searchPredicate
            }

        } else {
            // has segmented control only
            request.predicate = inventoryPredicate
        }

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }

    // MARK: - Actions
    
    @IBAction func displayLoginVCmodally(_ sender: UIBarButtonItem) {
        if (FBSDKAccessToken.current() != nil) {
            loginManager.logOut() // this is an instance function
            print("******* logOut of Facebook from gear button")
            settingsButton.title = "Login"
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.present(vc, animated: true, completion: nil)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("*** From VC Did log out of facebook")
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            let alert = UIAlertController(title: "Error", message: "Error during Firebase login.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("*** From VC Successfully logged in with facebook...")
    }

    @IBAction func statusChanged(_ sender: Any) {

        switch (inventorySegmentedControl.selectedSegmentIndex) {
        case 0:
            inventoryPredicate = nil
            break
        case 1:
            let haveValue = true
            inventoryPredicate = NSPredicate(format: "have == %@", haveValue as CVarArg)
            break
        case 2:
            let haveValue = false
            inventoryPredicate = NSPredicate(format: "have == %@", haveValue as CVarArg)
            break
        case 3:
            let needValue = true
            inventoryPredicate = NSPredicate(format: "need == %@", needValue as CVarArg)
            break
        default:
            break

        }
        initializeFetchedResultsController()
        tableView.reloadData()
    }

    // Search Functionality
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty  {

            let predicate1 = NSPredicate(format: "paint_name contains [cd] %@", searchText)
            let predicate2 = NSPredicate(format: "paint_number contains [cd] %@", searchText)
            let predicate3 = NSPredicate(format: "pigments contains [cd] %@", searchText)
            let predicate4 = NSPredicate(format: "other_names contains [cd] %@", searchText)
            let predicate5 = NSPredicate(format: "staining_granulating contains [cd] %@", searchText)
            let predicate6 = NSPredicate(format: "opacity contains [cd] %@", searchText)
            let predicate7 = NSPredicate(format: "color_family contains [cd] %@", searchText)
            
            searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:[predicate1, predicate2, predicate3, predicate4, predicate5, predicate6, predicate7])
            
        } else {
            searchPredicate = nil
            
        }
        initializeFetchedResultsController()
        tableView.reloadData()
    }
    
}
