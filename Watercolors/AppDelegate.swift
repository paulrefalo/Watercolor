//
//  AppDelegate.swift
//  Watercolors
//
//  Created by Paul ReFalo on 4/4/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "Watercolors")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
        guard let navController = window?.rootViewController as? UINavigationController,
            let viewController = navController.topViewController as? ViewController else {
                return true
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        
        //test line to force skip loginVC
//        UserDefaults.standard.set("Leisa", forKey: "name")
//        UserDefaults.standard.set(nil, forKey: "name")
        
//        if (UserDefaults.standard.value(forKey: "name") as? String) == nil {
        
        print("Current ID", FBSDKAccessToken.current())
        if (FBSDKAccessToken.current() == nil) {
            // Not logged in to fb so -> show onboarding screen
            vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        } else {
            // Already logged into FB so -> show main screen
            vc = storyboard.instantiateInitialViewController()!
        }
        
        // guard navController block was here
        
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()

        viewController.managedContext = coreDataStack?.managedContext
        
        FIRApp.configure()

        importJSONSeedDataIfNeeded()

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack?.save()
    }

    func importJSONSeedDataIfNeeded() {

        let fetchRequest = NSFetchRequest<Paint>(entityName: "Paint")
        let count = try! coreDataStack?.managedContext.count(for: fetchRequest)

        print("paint count:" , count)


        let fetchRequest2 = NSFetchRequest<Pigment>(entityName: "Pigment")
        let count2 = try! coreDataStack?.managedContext.count(for: fetchRequest2)

        print("pigment count: ", count2)

        // load if there isn't data
        guard count == 0 else { return }

        do {
            let results = try coreDataStack?.managedContext.fetch(fetchRequest)
            results?.forEach({ coreDataStack?.managedContext.delete($0) })

            coreDataStack?.save()
            importJSONSeedData()
        } catch let error as NSError {
            print("Error fetching: \(error), \(error.userInfo)")
        }
    }

    func importJSONSeedData() {

        // load pigment
        let pigmentJsonURL = Bundle.main.url(forResource: "pigment", withExtension: "json")!
        let pigmentJsonData = NSData(contentsOf: pigmentJsonURL) as! Data
        let pigmentJsonArray = try! JSONSerialization.jsonObject(with: pigmentJsonData, options: [.allowFragments]) as! [AnyObject]

        for pigmentJsonDictionary in pigmentJsonArray {


            let pigment_name  = pigmentJsonDictionary["pigment_name"] as? String ?? ""
            let toxicity = pigmentJsonDictionary["toxicity"] as? String ?? ""
            let properties = pigmentJsonDictionary["properties"] as? String ?? ""
            let pigment_words = pigmentJsonDictionary["pigment_words"] as? String ?? ""
            let pigment_type = pigmentJsonDictionary["pigment_type"] as? String ?? ""
            let pigment_code = pigmentJsonDictionary["pigment_code"] as? String ?? ""
            let permanence = pigmentJsonDictionary["permanence"] as? String ?? ""
            let image_name = pigmentJsonDictionary["image_name"] as? String ?? ""
            let history = pigmentJsonDictionary["history"] as? String ?? ""
            let chemical_name = pigmentJsonDictionary["chemical_name"] as? String ?? ""
            let chemical_formula = pigmentJsonDictionary["chemical_formula"] as? String ?? ""
            let alternative_names = pigmentJsonDictionary["alternative_names"] as? String ?? ""

            let pigment = Pigment.pigment(withName: pigment_name, in: (coreDataStack?.managedContext)!)

            pigment.toxicity = toxicity
            pigment.properties = properties
            pigment.pigment_words = pigment_words
            pigment.pigment_type = pigment_type
            pigment.pigment_code = pigment_code
            pigment.permanence = permanence
            pigment.image_name = image_name
            pigment.history = history
            pigment.chemical_name = chemical_name
            pigment.chemical_formula = chemical_formula
            pigment.alternative_names = alternative_names

        }

        // load paint
        let paintJsonURL = Bundle.main.url(forResource: "paint", withExtension: "json")!
        let paintJsonData = NSData(contentsOf: paintJsonURL)! as Data
        let paintJsonArray = try! JSONSerialization.jsonObject(with: paintJsonData, options: [.allowFragments]) as! [AnyObject]

        for paintJsonDictionary in paintJsonArray {

            let temperature = paintJsonDictionary["temperature"] as? String ?? ""
            let staining_granulating = paintJsonDictionary["staining_granulating"] as? String ?? ""
            let sort_order = paintJsonDictionary["sort_order"] as? Int16 ?? 0
            let pigments = paintJsonDictionary["pigments"] as? String ?? ""
            let pigment_composition = paintJsonDictionary["pigment_composition"] as? String ?? ""
            let paint_number = paintJsonDictionary["paint_number"] as? Int16 ?? 0
            let paint_name = paintJsonDictionary["paint_name"] as? String ?? ""
            let paint_history = paintJsonDictionary["paint_history"] as? String ?? ""
            let other_names = paintJsonDictionary["other_names"] as? String ?? ""
            let opacity = paintJsonDictionary["opacity"] as? String ?? ""
            let need = paintJsonDictionary["need"] as? Bool ?? false
            let lightfast_rating = paintJsonDictionary["lightfast_rating"] as? String ?? ""
            let have = paintJsonDictionary["have"] as? Bool ?? false
            let color_family = paintJsonDictionary["color_family"] as? String ?? ""

            let paint = Paint.paint(withName: paint_name, in: (coreDataStack?.managedContext)!)

            paint.temperature = temperature
            paint.staining_granulating = staining_granulating
            paint.sort_order = sort_order
            paint.pigment_composition = pigment_composition
            paint.paint_number = paint_number
            paint.paint_name = paint_name
            paint.paint_history = paint_history
            paint.other_names = other_names
            paint.opacity = opacity
            paint.need = need
            paint.lightfast_rating = lightfast_rating
            paint.have = have
            paint.color_family = color_family
            paint.pigments = pigments

            // this is the relationship between paint and pigments
            let pigmentArray: [String]? = pigments.components(separatedBy: ",")
            for pigmentStr in pigmentArray! {

                let aPigment = Pigment.pigment(withName: pigmentStr, in: (coreDataStack?.managedContext)!)
                paint.addToContains(aPigment)

            }
        }

        coreDataStack?.save()
    } // end func importJSONSeedData
}
