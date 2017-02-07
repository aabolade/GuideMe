//
//  TrainTimeTests.swift
//  GuideMe
//
//  Created by Pea M. Tyczynska on 07/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import XCTest
@testable import GuideMe

class TrainTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testStringFormatting() {
        let trainTime = TrainTime()
        let formattedString = trainTime.formatTimeStringFromAPI(string: "2017-02-07T12:05:19Z")
        XCTAssertEqual(formattedString, "2017-02-07 12:05:19")
    }
    
    func testDateFormatting() {
        let trainTime = TrainTime()
        let formatter = trainTime.setUpDateFormatter().dateFormatter
        let formattedDate = trainTime.makeDateFromString(formatter: formatter, string: "2017-02-07 12:05:19")
        XCTAssertTrue((formattedDate as Any) is Date)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
