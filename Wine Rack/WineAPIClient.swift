//
//  WineAPIClient.swift
//  Wine Rack
//
//  Created by David Gibbs on 16/04/2017.
//  Copyright © 2017 SixtySticks. All rights reserved.
//

import Foundation

class WineAPIClient {
    
    // MARK: Shared Instance
    class func sharedInstance() -> WineAPIClient {
        struct Singleton {
            static var sharedInstance = WineAPIClient()
        }
        return Singleton.sharedInstance
    }
    
    // Search Wine API
    func searchforWine(searchquery: String, completionHandlerForSearch: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        let session = URLSession.shared
        
        let params: [String: AnyObject] = [
            Constants.APIParamKey.ApiKey: Constants.APIParamValue.ApiKey as AnyObject,
            Constants.APIParamKey.SearchQuery: searchquery as AnyObject
        ]
        
        let request = URLRequest(url: buildWineSearchURLFromParams(params))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                self.printError("There was an error with your request!")
                completionHandlerForSearch(nil, "There was an error with your request!")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.printError("We did not get a successful 2XX response!")
                completionHandlerForSearch(nil, "We did not get a successful 2XX response!")
                return
            }
            
            // GUARD: Was there a successful request?
            guard (data != nil) else {
                self.printError("There was no data returned!")
                completionHandlerForSearch(nil, "There was no data returned!")
                return
            }
            
            self.parseJSON(data!, completionHandlerForJSON: completionHandlerForSearch)
            
        }
        
        task.resume()

    }
    
    // MARK: BUILD FLICKR URL

    private func buildWineSearchURLFromParams(_ params: [String: AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.APIUrl.Scheme
        components.host = Constants.APIUrl.Host
        components.path = Constants.APIUrl.Path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: PARSE JSON DATA
    
    private func parseJSON(_ data: Data, completionHandlerForJSON: (_ result: [String: AnyObject]?, _ error: String?) -> Void) {
        
        let parsedResult: AnyObject!
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject!
        } catch {
            completionHandlerForJSON(nil, "Error parsing JSON")
            return
        }
        completionHandlerForJSON(parsedResult as? [String: AnyObject], nil)
    }
    
    // MARK: ERROR MESSAGE FUNCTION
    
    func printError(_ error: String) {
        print("ERROR: \(error)")
    }
    
}
