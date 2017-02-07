//
//  GuideMeTests.swift
//  GuideMeTests
//
//  Created by Pea M. Tyczynska on 06/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import XCTest
import Alamofire
import CoreLocation
@testable import GuideMe

class GuideMeTests: XCTestCase {
    
    var viewController : ViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        let _ = viewController.view
    }
    
    func testBackgroundColorisBlack() {
        let backgroundColor = viewController.view.backgroundColor
        XCTAssertEqual(backgroundColor, UIColor.black)
    }
    
    func testStartMessageIsGuideMe() {
        let startMessage = viewController.distanceReading.text
        XCTAssertEqual(startMessage, "Welcome to Guide Me")
    }
    
    func testFontStyle() {
        let fontStyle = viewController.distanceReading.font.fontName
        XCTAssertEqual(fontStyle, "Courier-Bold")
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
