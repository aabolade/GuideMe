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
        let currentDate = Date()
        let formatter = setUpDateFormatter().dateFormatter
        let componentsFormatter = setUpDateFormatter().dateComponentsFormatter
        let formattedTrainTime = formatTimeStringFromAPI(string: trainTime)
        let trainDate = makeDateFromString(formatter: formatter, string: formattedTrainTime)
        let timeDifference = dateDifferenceString(componentsFormatter: componentsFormatter, from: trainDate, to: currentDate)
        return timeInMins(time: timeDifference)
    }
    
    
    func setUpDateFormatter() -> (dateFormatter: DateFormatter, dateComponentsFormatter: DateComponentsFormatter) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
        return (dateFormatter, dateComponentsFormatter)
    }

    
    func formatTimeStringFromAPI(string: String) -> String {
        return String(string.characters.dropLast(1)).replacingOccurrences(of: "T", with: " ")
    }
    

    func makeDateFromString(formatter: DateFormatter, string: String) -> Date {
        return formatter.date(from: string)!
    }
    
    
    func dateDifferenceString(componentsFormatter: DateComponentsFormatter,from: Date, to: Date) -> String {
        return componentsFormatter.string(from: from, to: to)!
    }
    
    
    func timeInMins(time: String) -> String {
        return (time.components(separatedBy: ",").first)!
    }
    
    
}
