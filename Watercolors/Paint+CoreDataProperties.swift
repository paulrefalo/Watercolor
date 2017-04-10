//
//  Paint+CoreDataProperties.swift
//  Watercolors
//
//  Created by Leisa Refalo on 4/10/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import Foundation
import CoreData


extension Paint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Paint> {
        return NSFetchRequest<Paint>(entityName: "Paint");
    }

    @NSManaged public var color_family: String?
    @NSManaged public var have: Bool
    @NSManaged public var lightfast_rating: String?
    @NSManaged public var need: Bool
    @NSManaged public var opacity: String?
    @NSManaged public var other_names: String?
    @NSManaged public var paint_history: String?
    @NSManaged public var paint_name: String?
    @NSManaged public var paint_number: Int16
    @NSManaged public var pigment_composition: String?
    @NSManaged public var pigments: String?
    @NSManaged public var sort_order: Int16
    @NSManaged public var staining_granulating: String?
    @NSManaged public var temperature: String?
    @NSManaged public var contains: NSSet?

}

// MARK: Generated accessors for contains
extension Paint {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Pigment)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Pigment)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
