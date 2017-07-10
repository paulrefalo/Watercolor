//
//  LoginVC.swift
//  Watercolors
//
//  Created by Paul ReFalo on 6/3/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import Firebase
import FirebaseDatabase

class LoginVC: UIViewController, FBSDKLoginButtonDelegate, NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    let ref = FIRDatabase.database().reference(withPath: "Watercolors")
    var retrievedTime = Int()
    var firebaseData = NSDictionary()
    var currentPaint: Paint!
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController<Paint>!
    var syncPredicate: NSPredicate?
    
    let progressInd = ActivityInd(text: "Syncing data")

    
    // MARK: - IBOutlets and Actions

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var loginText: UILabel!

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var cancelButton: UIButton!

    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("Cancel/Skip button pressed")
        if (FBSDKAccessToken.current() != nil) {
            self.dismiss(animated: true, completion: nil)
        } else {
            presentInitialVC()
        }
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = UIColor(patternImage: UIImage(named: "watercolor background")!)
        loginText.layer.zPosition = 5       // set zPosition of label and button so emitter goes to the back
        cancelButton.layer.zPosition = 6
        reconfigurePage()                   // set up page for either logged in or not status

        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("User is currently logged in with FB")
            print("Logged in as: ", FBSDKAccessToken.current().userID)

            // page setup when logged in.  Set: welcome/hello text, toggle skip/cancel button
            if let firstName = UserDefaults.standard.string(forKey: "userFirstName") {
                topLabel.text = "Hi, \(firstName)!"
            }

            // Each time loginVC loads, if logged into FB and Firebase db exists, perform sync

            if let userID = FIRAuth.auth()?.currentUser?.uid {
                ref.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in

                    let refData = snapshot.value as? NSDictionary
                    let firebaseTime = refData?["Time of Sync"]

                    if firebaseTime != nil {
                        print("***firebaseTime in loginButton is:  ", firebaseTime ?? 42)
                        refData?.forEach { print("\($0): \($1)") }

                        // Firebase entry for user exists -> sync data
                        self.syncDataWithFirebase(userID: userID, firebaseTime: firebaseTime as! Int, refData: refData)
                    } else {
                        // Firebase entry for user NOT found -> seed Firebase DB
                        print("No user found in Firebase, will call seedFirebaseDB")
                        self.seedFirebaseDB(userID: userID)
                    }
                })
                
            } else {
                print("error getting Firebase UserID")
            }

        } else {
            progressInd.hide()
            emitter()  // start emitter
            loginText.isHidden = false
        }
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]

        loginButton.frame = CGRect(x: 16, y: 200, width: view.frame.width - 32, height: 50) // set the frame for FB button

        view.addSubview(loginButton)    // add FB button to the page

        loginButton.delegate = self
        
        // Create and add activity indicator to screen

        self.view.addSubview(progressInd)
        progressInd.backgroundColor = UIColor.darkGray
        progressInd.layer.zPosition = 7
    }

    // MARK: - Functions

    func reconfigurePage() {

        if (FBSDKAccessToken.current() != nil) {
            // User is logged in with FB
            coverView.alpha = 0.5
            cancelButton.setTitle("Cancel", for: .normal)
            let dateString = getDateFormatString()

            if dateString == "" {
                loginText.text = "Data will be automatically sync"
            } else {
               loginText.text = "Last data sync at \(dateString)"
            }
        } else {
            // User NOT logged in
            topLabel.text = "Welcome!"
            coverView.alpha = 0.2
            cancelButton.setTitle("Skip", for: .normal)
            loginText.text = "Login to sync and save your paint inventory"
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
        reconfigurePage()
        presentInitialVC()
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if error != nil {
            print(error)
            let alert = UIAlertController(title: "Error", message: "Error during Facebook login.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            
            if let userID = FIRAuth.auth()?.currentUser?.uid {
                
                ref.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let refData = snapshot.value as? NSDictionary
                    let firebaseTime = refData?["Time of Sync"]
                    
                    if firebaseTime != nil {
                        print("firebaseTime in loginButton is:  ", firebaseTime ?? 43)

                        // Firebase entry for user exists -> sync data
                        print("*** Found child from observeSingleEvent")
                        self.syncDataWithFirebase(userID: userID, firebaseTime: firebaseTime as! Int, refData: refData)
                    } else {
                        // Firebase entry for user NOT found -> see Firebase DB
                        print("No user found in Firebase, will call seedFirebaseDB")
                        self.seedFirebaseDB(userID: userID)
                    }
                })
                
            } else {
                print("error getting Firebase UserID")
            }
            
            presentInitialVC()

            // Firebase Login
            self.firebaseLogin()
        }

        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in

            if err != nil {
                print("Failed to start graph request:", err as Any)
                let alert = UIAlertController(title: "Error", message: "Error during Firebase request.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                print(result as Any)
                let fbDetails = result as! NSDictionary
                print(fbDetails)
                if let name: String = fbDetails["name"] as? String {

                    let fullNameArray = name.components(separatedBy: " ")

                    let firstName = fullNameArray[0]
                    let surname = fullNameArray[1]

                    UserDefaults.standard.set(name, forKey: "fullUserName")
                    UserDefaults.standard.set(firstName, forKey: "userFirstName")
                    UserDefaults.standard.set(surname, forKey: "userSurname")

                    print("*** First is:", firstName)
                    print("*** Surname is:", surname)

                    self.topLabel.text = "Hi, \(firstName)!"
                }
                if let id: String = fbDetails["id"] as? String {
                    print("*** Id is:  ", id)
                }
                if let email: String = fbDetails["email"] as? String {
                    print("*** Email is:  ", email)
                    UserDefaults.standard.set(email, forKey: "userEmail")
                }

            }
        }
    }

    func presentInitialVC() {  // transition to PaintListTVC

        if let tabViewController = storyboard?.instantiateViewController(withIdentifier: "InitialTabBarController") as? UITabBarController {
            present(tabViewController, animated: true, completion: nil)
        }
    }

    func firebaseLogin() {

        if let accessTokenString = FBSDKAccessToken.current().tokenString {
            let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                if error != nil {
                    print("! Error on Firebase Login: \(String(describing: error))")
                    let alert = UIAlertController(title: "Error", message: "Error during Firebase login.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    print("******* Successful Firebase Login as: ", user as Any)
                    if let FirebaseUID = FIRAuth.auth()?.currentUser?.uid {
                        print("******* FirebaseUID: ", FirebaseUID)
                    }
                    if FIRAuth.auth()?.currentUser?.uid != nil {
                        UserDefaults.standard.set(true, forKey: "loggedIntoFirebase")
                        print("****** User is logged into Firebase")
                    }
                }
            })
        }
    }

    func emitter() {
        let emitter = Emitter.get(image: #imageLiteral(resourceName: "canvas"))
        emitter.emitterPosition = CGPoint(x: view.frame.size.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 2.0)
        view.layer.addSublayer(emitter)
    }

    func seedFirebaseDB(userID: String) {

        setTimeOfLastSync(userID: userID)
        
        if UserDefaults.standard.value(forKey: "fullUserName") == nil {
            UserDefaults.standard.set("", forKey: "fullUserName")
        }
        let fullName = UserDefaults.standard.value(forKey: "fullUserName")
        let nameRef = self.ref.child(userID).ref.child("Name")
        nameRef.setValue(fullName)

        // get array of paint numbers for Core Data
        let paintNumberArray: [Int] = getArrayOfPaintsFromCDS()

        // loop over array and make paintItems with paint number
        for paintNumber in paintNumberArray {
            let paintNumberString = "\(paintNumber)"
            let paintItem = PaintItem(paintNumber: paintNumberString, havePaint: 0, needPaint: 0)
            let paintItemRef = self.ref.child(userID).ref.child(paintNumberString)

            // add item to Firebase under ref.child(userID)
            paintItemRef.setValue(paintItem.toAnyObject())
        }

    }

    func setTimeOfLastSync(userID: String) {
        // set time in Firebase and UserDefaults.standard.set(time, forKey: "timeOfLastSync")
        let timeSinceEpoch = Int(Date().timeIntervalSince1970)
        print("Time: \(timeSinceEpoch)")
        let timeRef = self.ref.child(userID).ref.child("Time of Sync")
        timeRef.setValue(timeSinceEpoch)
        UserDefaults.standard.set(timeSinceEpoch, forKey: "timeOfLastSync")
    }

    func getDateFormatString() -> String {
        
        if let time = UserDefaults.standard.value(forKey: "timeOfLastSync") as? TimeInterval {
            
            let date = NSDate(timeIntervalSince1970: time) // app crashes if logged in??
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
            
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            
            return dateString
        }
        
        return ""
    }

    func getArrayOfPaintsFromCDS() -> Array<Int> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedContext

        let request = NSFetchRequest<Paint>(entityName: "Paint")

        var resultsArray = [Int]()

        do {
            let results = try managedContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            for result in results {
                let paintNumber = (result as AnyObject).value(forKey: "paint_number") as! Int
                resultsArray.append(paintNumber)
            }

        } catch let error as NSError {
            print("Could not fetch \(error)")
        }

        return resultsArray
    }

    func syncDataWithFirebase(userID: String, firebaseTime: Int, refData: NSDictionary?) {
        print("firebaseTime at start of sync:  ", firebaseTime)

        // user is logged in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.coreDataStack.managedContext
        
        // show Activity Indicator
        progressInd.show()

        // get array of paint numbers for Core Data
        let paintNumberArray: [Int] = getArrayOfPaintsFromCDS()

        // get time from Firebase and time from UserDefaults and then compare

        // user default guard statements
        guard UserDefaults.standard.value(forKey: "timeOfLastSync") as? Int != nil else {
            let timeSinceEpoch = Int(Date().timeIntervalSince1970)
            UserDefaults.standard.set(timeSinceEpoch, forKey: "timeOfLastSync")
            print("Guard statement setting timeSinceEpoch called")
            return
        }
        
        print("firebaseTime after guard statement:  ", firebaseTime)
        
        let CDStime = UserDefaults.standard.value(forKey: "timeOfLastSync") as! Int

        
        print("CDStime is:  ", CDStime)
        print("firebaseTime is:  ", firebaseTime)


        if CDStime == firebaseTime {

            // set time in CDS and Firebase
            print("Times equate -> no sync needed")

        } else if CDStime < firebaseTime ||
            UserDefaults.standard.value(forKey: "initialSyncWithFirebase") as! Bool == true {
            
            print("Sync from Firebase to CDS")

            // sync from Firebase to CDS if either Firebase has newer timestamp or this is initial CDS load
            // Update value so initial load can only happen once (e.g. get a new device or on app update)
            if UserDefaults.standard.value(forKey: "initialSyncWithFirebase") == nil ||
                UserDefaults.standard.value(forKey: "initialSyncWithFirebase") as! Bool == true {
                UserDefaults.standard.set(false, forKey: "initialSyncWithFirebase")
            }

            for (key, value) in (refData)! {
                let paintNumberString = key as! String
                if paintNumberString == "Time of Sync" || paintNumberString == "Name" {
                    continue
                }

                let valueDict: NSDictionary? = value as? NSDictionary
                // valueDict?.forEach { print("\($0): \($1)") }

                let havePaint = valueDict?["havePaint"] as! Int
                let needPaint = valueDict?["needPaint"] as! Int

                // get Paint from CoreData
                let request = NSFetchRequest<Paint>(entityName: "Paint")
                let paintSort = NSSortDescriptor(key: "sort_order", ascending: true)
                request.sortDescriptors = [paintSort]

                syncPredicate = NSPredicate(format: "paint_number == %@", paintNumberString)

                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)

                request.predicate = syncPredicate
                fetchedResultsController.delegate = self

                do {
                    let results = try managedContext.fetch(request)
                    let currentPaint = results.first

                    // update values in CoreData
                    if havePaint == 1 {
                        currentPaint?.have = true
                    } else {
                        currentPaint?.have = false
                    }

                    if needPaint == 1 {
                        currentPaint?.need = true
                    } else {
                        currentPaint?.need = false
                    }

                } catch let error as NSError {
                    print("Could not fetch \(error)")
                }

                // save context
                do {
                    if managedContext.hasChanges {
                        print("ManagedContext has Changes ***********")
                        try managedContext.save()
                    }
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }

        } else if CDStime > firebaseTime {
            // sync from CDS to Firebase
            print("Sync from CDS to Firebase")

            // loop over array and make paintItems with paint number
            for paintNumber in paintNumberArray {
                let paintNumberString = "\(paintNumber)"

                let request = NSFetchRequest<Paint>(entityName: "Paint")
                let paintSort = NSSortDescriptor(key: "sort_order", ascending: true)
                request.sortDescriptors = [paintSort]

                syncPredicate = NSPredicate(format: "paint_number == %@", paintNumberString)

                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)

                request.predicate = syncPredicate
                fetchedResultsController.delegate = self

                do {
                    let results = try managedContext.fetch(request)
                    let have = results.first?.value(forKey: "have") as! Int
                    let need = results.first?.value(forKey: "need") as! Int

                    let paintHaveRef = self.ref.child(userID).ref.child(paintNumberString).ref.child("havePaint")
                    paintHaveRef.setValue(have)

                    let paintNeedRef = self.ref.child(userID).ref.child(paintNumberString).ref.child("needPaint")
                    paintNeedRef.setValue(need)

                } catch let error as NSError {
                    print("Could not fetch \(error)")
                }
            }

        } else {
            print("This shouldn't happen")
        }
        
        // set time in CDS and Firebase
        setTimeOfLastSync(userID: userID)
        
        sleep(2)
        progressInd.hide()
        let dateString = getDateFormatString()
        loginText.text = "Last data sync at \(dateString)"
    }
    
}
