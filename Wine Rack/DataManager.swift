//
//  DataManager.swift
//  Wine Rack
//
//  Created by David Gibbs on 07/06/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    let stack = CoreDataStack.sharedInstance()
    
    // MARK: Shared Instance
    class func sharedInstance() -> DataManager {
        struct Singleton {
            static var sharedInstance = DataManager()
        }
        return Singleton.sharedInstance
    }
    
    func isInWineRack(wineId: Int32) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Wine")
        fetchRequest.predicate = NSPredicate(format: "inWineRack == true")
        
        do {
            let results = try stack.context.fetch(fetchRequest)
            if results.count > 0 {
                print("WINE ID: \(wineId)")
                return true
            } else {
                print("NO DICE")
                return false
            }
        } catch let error {
            print("searchInWineRack error: \(error)")
            return false
        }
    }
    
}
