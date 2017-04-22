//
//  Constants.swift
//  Wine Rack
//
//  Created by David Gibbs on 08/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation

struct Constants {
    
    struct NoWinesLabel {
        static let WineList = "You currently do not have any wines in your wine rack. Tap the search icon above to find wines you've recently enjoyed"
        static let WishList = "There are no wines on your wishlist. Tap the search icon above to browse"
    }
    
    struct APIUrl {
        static let Scheme = "http"
        static let Host = "services.wine.com"
        static let Path = "/api/\(Constants.APIPathExtensions.Version)/\(Constants.APIPathExtensions.Service)/\(Constants.APIPathExtensions.Format)/\(Constants.APIPathExtensions.CatalogResource)"
    }
    
    struct APIPathExtensions {
        static let Version = "beta2"
        static let Service = "service.svc"
        static let Format = "json"
        static let CatalogResource = "catalog"
    }
    
    struct APIParamKey {
        static let ApiKey = "apikey"
        static let SearchQuery = "search"
    }
    
    struct APIParamValue {
        static let ApiKey = "bff4cf354ef9ae90a3c9b4a49bed3d8d"
    }
    
}
