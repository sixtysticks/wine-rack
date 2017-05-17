//
//  Wine+CoreDataClass.swift
//  Wine Rack
//
//  Created by David Gibbs on 29/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation
import CoreData

@objc(Wine)
public class Wine: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, dictionary: [String: AnyObject]) {
        if let ent = NSEntityDescription.entity(forEntityName: "Wine", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = dictionary["Id"] as? String
            self.name = dictionary["Name"] as? String
            self.url = dictionary["Url"] as? String
            self.wineType = dictionary["Varietal"]?["Name"] as? String
            self.vintage = dictionary["Vintage"] as? String
            self.creationDate = Date() as NSDate?
            
            if let labels = dictionary["Labels"] as? [AnyObject], let label = labels.first {
                let originalLabelUrl = label["Url"] as? String
                let updatedLabelUrl = replaceImageSuffix(originalLabelUrl!)
                self.labelUrl = updatedLabelUrl
            }
        } else {
            fatalError("Unable to find entity name")
        }
    }
    
    private func replaceImageSuffix(_ originalString: String) -> String {
        return originalString.replacingOccurrences(of: Constants.General.LabelUrlMedium, with: Constants.General.LabelUrlLarge)
    }

}
