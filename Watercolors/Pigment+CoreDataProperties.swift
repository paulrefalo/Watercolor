//
//  Pigment+CoreDataProperties.swift
//  Watercolors
//
//  Created by Leisa Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import Foundation
import CoreData


extension Pigment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pigment> {
        return NSFetchRequest<Pigment>(entityName: "Pigment");
    }

    @NSManaged public var alternative_names: String?
    @NSManaged public var chemical_formula: String?
    @NSManaged public var chemical_name: String?
    @NSManaged public var history: String?
    @NSManaged public var image_name: String?
    @NSManaged public var permanence: String?
    @NSManaged public var pigment_code: String?
    @NSManaged public var pigment_type: String?
    @NSManaged public var pigment_words: String?
    @NSManaged public var properties: String?
    @NSManaged public var toxicity: String?
    @NSManaged public var pigment_name: String?
    @NSManaged public var used_in: Paint?

}
