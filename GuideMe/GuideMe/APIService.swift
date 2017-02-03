//
//  APIService.swift
//  GuideMe
//
//  Created by Leke Abolade on 03/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation

struct APIService {
    
    func makeHTTPRequest() {
        
        if let stationURLString = URL(string: "https://api.tfl.gov.uk/StopPoint/940GZZLUADE/Arrivals") {
            let networkOperation = Network(url: stationURLString)
            
            networkOperation.downloadJSONFromURL {
                (JSONDictionary) in
                
                print(JSONDictionary)
                
                
            }

        }
        
    }
    
}
