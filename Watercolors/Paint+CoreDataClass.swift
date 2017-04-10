//
//  Paint+CoreDataClass.swift
//  Watercolors
//
//  Created by Leisa Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import Foundation
import CoreData


public class Paint: NSManagedObject {

    // get a paint with the given name. creates if DNE
    class func paint(withName name: String, in context: NSManagedObjectContext) -> Paint {

    let paintEntity = NSEntityDescription.entity(forEntityName: "Paint", in: context)!
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Paint")
    request.predicate = NSPredicate(format: "paint_name = %@", name)
    if let matches = try? context.fetch(request) {
        if matches.count > 0 {
          //  print("found ", name)
            return matches.last as! Paint
        }

    }

    let thisPaint = Paint(entity:paintEntity, insertInto: context)
    thisPaint.paint_name = name
       // print ("add" , name)
    return thisPaint

}

}
