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
    
    func findWineById(_ wineId: Int32) -> Wine? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Wine")
        fetchRequest.predicate = NSPredicate(format: "id == \(wineId)")
        
        do {
            let results = try stack.context.fetch(fetchRequest)
            if results.count == 1 {
                return (results.first as! Wine)
            }
        } catch let error {
            print("findWineById error: \(error)")
        }
        return nil
    }
    
}
