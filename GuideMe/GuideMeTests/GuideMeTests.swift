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
    
    func testReplyFromBeacons() {
        viewController.giveDirections(beaconNumber: 1)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "Entering Algate station")
    }
    
    func testReplyFromBeaconMinorFromRoad1() {
        viewController.giveDirections(beaconNumber: 41693)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "Stairs ahead, go down 56 steps")
    }
    
    func testReplyFromBeaconMinorFromRoad49281() {
        viewController.giveDirections(beaconNumber: 49281)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "Turn Left")
    }
    
    func testReplyFromBeaconMinorFromRoad651659() {
        viewController.giveDirections(beaconNumber: 65159)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "You are now on the Algate platform")
    }
    
    func testReplyFromBeaconMinorFromTrain1() {
        viewController.lastBeacon = 41693
        viewController.giveDirections(beaconNumber: 1)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "You are exiting Algate station")
    }
    
    func testReplyFromBeaconMinorFromTrain49281() {
        viewController.lastBeacon = 65159
        viewController.giveDirections(beaconNumber: 49281)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "Turn Right")
    }
    
    func testReplyFromBeaconMinorFromTrain41693() {
        viewController.lastBeacon = 49281
        viewController.giveDirections(beaconNumber: 41693)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "Stairs ahead, go up 56 steps")
    }
    
    func testReplyFromBeaconMinorFromTrain65159() {
        viewController.lastBeacon = 65159
        viewController.giveDirections(beaconNumber: 65159)
        let message = viewController.distanceReading.text
        XCTAssertEqual(message, "You are now on the Algate platform")
    }
    
    


    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
