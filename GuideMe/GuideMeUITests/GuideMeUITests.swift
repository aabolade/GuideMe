//
//  GuideMeUITests.swift
//  GuideMe
//
//  Created by Pea M. Tyczynska on 07/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import XCTest

class GuideMeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    
    
    func testInputTextMovesToNextView() {
        
        let app = XCUIApplication()
     
        let textField = app.otherElements.containing(.navigationBar, identifier:"GuideMe.HomeView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element
        textField.tap()
        textField.typeText("wimbledon")
        
        let element = app.otherElements.containing(.navigationBar, identifier:"GuideMe.HomeView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        let guideMeButton = app.buttons["Guide Me!"]
        guideMeButton.tap()
        let messageStaticText = app.staticTexts["message"]
        XCTAssertEqual(messageStaticText.label, "Welcome to Guide Me. You are being guided to: wimbledon")
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    
}
