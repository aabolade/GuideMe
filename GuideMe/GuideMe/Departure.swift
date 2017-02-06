//
//  Departure.swift
//  GuideMe
//
//  Created by Leke Abolade on 06/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation


struct Departure {
    
        let platformName: String?
        let lineName: String?
        let arrivalTime: String?
        let destinationName: String?
    
    
        init(departureDictionary: [String: AnyObject]) {
        
                    platformName = departureDictionary["platformName"] as? String
                    lineName = departureDictionary["lineName"] as? String
                    arrivalTime = departureDictionary["expectedArrival"] as? String
                   destinationName = departureDictionary["towards"] as? String
                    
           }
    }
