//
//  APIService.swift
//  GuideMe
//
//  Created by Leke Abolade on 05/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    typealias JSONDictionaryCompletion = (Departure?) -> Void
    
    func getLiveDepartures(_ completion: @escaping JSONDictionaryCompletion) {
        
        Alamofire.request("https://api.tfl.gov.uk/StopPoint/940GZZLUADE/Arrivals").responseJSON { response in
            
            guard let JSON = response.result.value as? [[String: Any]] else {
                print("There is no data")
                return
            }
            if JSON.count > 0 {
                let currentDepartures = Departure(departureDictionary: JSON[0] as [String : AnyObject])
                completion(currentDepartures)
            } else {
                print("No data")
                return
            }
            
            
        }
        
    }
    
}
