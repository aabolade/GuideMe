//
//  TrainTime.swift
//  GuideMe
//
//  Created by Leke Abolade on 06/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation

class TrainTime {
    
        func formatArrivalTime(trainTime: String) -> String {
        
                let dateFormatter = DateFormatter()
                let currentDate = Date()
                var trainTime = trainTime
                var formattedTrainTime = String(trainTime.characters.dropLast(1)).replacingOccurrences(of: "T", with: " ")
        
        
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                var trainTimeAsDate = dateFormatter.date(from: formattedTrainTime)
        
        
                let dateComponentsFormatter = DateComponentsFormatter()
                dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
        
               let autoFormattedDifference = dateComponentsFormatter.string(from: trainTimeAsDate!, to: currentDate as Date)
        
                return (autoFormattedDifference?.components(separatedBy: ",").first)!
            
            }
    
    }
