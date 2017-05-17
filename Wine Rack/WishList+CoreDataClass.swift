//
//  WishList+CoreDataClass.swift
//  Wine Rack
//
//  Created by David Gibbs on 30/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation
import CoreData

@objc(WishList)
public class WishList: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "WishList", in: context) {
            self.init(entity: ent, insertInto: context)
            do {
                try CoreDataStack.sharedInstance().saveContext()
            } catch {
                fatalError("Error in 'WishList' NSManagedObject")
            }
        } else {
            fatalError("Unable to find entity name")
        }
    }

}
