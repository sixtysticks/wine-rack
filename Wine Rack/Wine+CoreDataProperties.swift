//
//  Wine+CoreDataProperties.swift
//  Wine Rack
//
//  Created by David Gibbs on 01/06/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation
import CoreData


extension Wine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wine> {
        return NSFetchRequest<Wine>(entityName: "Wine")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var labelUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var vintage: String?
    @NSManaged public var wineType: String?
    @NSManaged public var onWishlist: Bool
    @NSManaged public var inWineRack: Bool

}
