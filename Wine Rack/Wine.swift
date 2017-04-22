//
//  Wine.swift
//  Wine Rack
//
//  Created by David Gibbs on 16/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation

class Wine {
    
    static var wines = [Wine]()
    
    var id: String?
    var name: String?
    var url: String?
    var wineType: String?
    var labelUrl: String?
    var vintage: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["Id"] as? String
        self.name = dictionary["Name"] as? String
        self.url = dictionary["Url"] as? String
        self.wineType = dictionary["Varietal"]?["Name"] as? String
        self.labelUrl = dictionary["Labels"]?["Url"] as? String
        self.vintage = dictionary["Vintage"] as? String
    }
}
