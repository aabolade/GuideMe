//
//  TrainTimeTests.swift
//  GuideMe
//
//  Created by Pea M. Tyczynska on 07/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import XCTest
@testable import GuideMe

let trainTime = TrainTime()
let formatter = trainTime.setUpDateFormatter().dateFormatter
let componentsFormatter = trainTime.setUpDateFormatter().dateComponentsFormatter

class TrainTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testStringFormatting() {
        
        let formattedString = trainTime.formatTimeStringFromAPI(string: "2017-02-07T12:05:19Z")
        XCTAssertEqual(formattedString, "2017-02-07 12:05:19")
    }
    
    func testDateFormatting() {
        let formattedDate = trainTime.makeDateFromString(formatter: formatter, string: "2017-02-07 12:05:19")
        XCTAssertTrue((formattedDate as Any) is Date)
    }
    
    func testCalculatingDateDifference() {
        let from_date = trainTime.makeDateFromString(formatter: formatter, string: "2017-02-07 12:00:00")
        let to_date = trainTime.makeDateFromString(formatter: formatter, string: "2017-02-07 12:05:00")
        let difference = trainTime.dateDifferenceString(componentsFormatter: componentsFormatter,from: from_date, to: to_date)
        XCTAssertEqual(difference, "5 minutes")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
