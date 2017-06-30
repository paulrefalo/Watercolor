//
//  ViewController.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    
    // MARK: - IBOutlets

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.coreDataStack?.managedContext
    }
    
    @IBAction func displayLoginVCmodally(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("*** From VC Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("*** From VC Successfully logged in with facebook...")
        
    }

    // MARK: - Navigation

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
