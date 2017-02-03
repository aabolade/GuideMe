//
//  Networking.swift
//  GuideMe
//
//  Created by Leke Abolade on 03/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation

class Network {
    
    lazy var config: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.config)
    
    let queryURL: URL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: URL) {
        self.queryURL = url
    }

    
    func downloadJSONFromURL(_ completion: @escaping JSONDictionaryCompletion) {
        
        
        let request: URLRequest = URLRequest(url: queryURL)
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        
                        print(jsonDictionary)
                        completion(jsonDictionary)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    
                default:
                    
                    print("Get request not successful. HTTP status code: \(httpResponse.statusCode)")
                }
                
            } else {
                print("Error: Not a valid HTTP response")
            }
        })
        
        dataTask.resume()
    }
    
    

}
