//
//  WineRack+CoreDataClass.swift
//  Wine Rack
//
//  Created by David Gibbs on 29/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation
import CoreData

@objc(WineRack)
public class WineRack: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "WineRack", in: context) {
            self.init(entity: ent, insertInto: context)
            do {
                try CoreDataStack.sharedInstance().saveContext()
            } catch {
                fatalError("Error in 'WineRack' NSManagedObject")
            }
        } else {
            fatalError("Unable to find entity name")
        }
    }

}
