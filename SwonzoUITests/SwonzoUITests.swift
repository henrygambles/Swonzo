//
//  SwonzoUITests.swift
//  SwonzoUITests
//
//  Created by Henry Gambles on 10/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import XCTest


class SwonzoUITests: XCTestCase {
    
    let app = XCUIApplication()
    

    override func setUp() {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testLogIn() {
        app.buttons["Log In"].tap()
        sleep(1)
    }
    
    func testTapHomeTab() {
        //        app.textFields["tokenTextField"].typeText("xyztwh4ththwt")
        app.buttons["Log In"].tap()
        app.tabBars.buttons["Home"].tap()
        sleep(2)
        //        XCTAssert(app.navigationBars["Home"].exists)
    }
    
    func testTapMapsTab() {
        app.buttons["Log In"].tap()
        app.tabBars.buttons["Maps"].tap()
        sleep(1)
        app.swipeLeft()
        app.swipeRight()
        sleep(2)
    }
    
    func testTapTransactionsTab() {
        app.buttons["Log In"].tap()
        app.tabBars.buttons["Transactions"].tap()
        sleep(3)
    }
    
    func testTapDevTab() {
        app.buttons["Log In"].tap()
        app.tabBars.buttons["Dev"].tap()
        sleep(3)
    }
    
    func testLoadTransactions() {
        app.buttons["Log In"].tap()
        app.tabBars.buttons["Transactions"].tap()
        sleep(20)
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
    }
}
