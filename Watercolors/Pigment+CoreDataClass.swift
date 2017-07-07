//
//  Pigment+CoreDataClass.swift
//  Watercolors
//
//  Created by Paul Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import Foundation
import CoreData

public class Pigment: NSManagedObject {

    // get a pigment with the given name. creates if DNE
    class func pigment(withName name: String, in context: NSManagedObjectContext) -> Pigment {


        let pigmentEntity = NSEntityDescription.entity(forEntityName: "Pigment", in: context)!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pigment")
        request.predicate = NSPredicate(format: "pigment_name = %@", name)
        if let matches = try? context.fetch(request) {
            if matches.count > 0 {
             //   print("found ", name)
                return matches.last as! Pigment
            }

        }
        let thisPigment = Pigment(entity:pigmentEntity, insertInto: context)
        thisPigment.pigment_name = name
      //  print ("add" , name)
        return thisPigment
        
    }
}
