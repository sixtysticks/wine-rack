//
//  WishList+CoreDataProperties.swift
//  Wine Rack
//
//  Created by David Gibbs on 15/05/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation
import CoreData


extension WishList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WishList> {
        return NSFetchRequest<WishList>(entityName: "WishList")
    }

    @NSManaged public var wines: NSSet?

}

// MARK: Generated accessors for wines
extension WishList {

    @objc(addWinesObject:)
    @NSManaged public func addToWines(_ value: Wine)

    @objc(removeWinesObject:)
    @NSManaged public func removeFromWines(_ value: Wine)

    @objc(addWines:)
    @NSManaged public func addToWines(_ values: NSSet)

    @objc(removeWines:)
    @NSManaged public func removeFromWines(_ values: NSSet)

}
