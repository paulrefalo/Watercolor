//
//  ViewController.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: - Properties
var managedContext: NSManagedObjectContext!
 // MARK: - IBOutlets
          // MARK: - View Life Cycle
    override func viewDidLoad() {
       super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "PaintSearchSegue" {
            if let nextViewController = segue.destination as? SearchPaintTVC {
                nextViewController.managedContext = self.managedContext
            }
        } else if segue.identifier == "PigmentSearchSegue" {
            if let nextViewController = segue.destination as? SearchPigmentTCV {
                nextViewController.managedContext = self.managedContext
            }
        } else if segue.identifier == "InventorySegue" {
            if let nextViewController = segue.destination as? InventoryTVC {
                nextViewController.managedContext = self.managedContext
            }
        } else if segue.identifier == "SelectColorSegue" {
            if let nextViewController = segue.destination as? SelectColorVC {
                nextViewController.managedContext = self.managedContext
            }
        }

    }


}
