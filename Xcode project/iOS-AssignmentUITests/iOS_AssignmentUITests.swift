//
//  iOS_AssignmentUITests.swift
//  iOS-AssignmentUITests
//
//  Created by Carlos Roldan on 27/11/2018.
//  Copyright © 2018 Carlos Roldan. All rights reserved.
//

import XCTest

class iOS_AssignmentUITests: XCTestCase {

    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFirstScreen() {
        //  given scenario 1
        //  where I test there is a UI element got selecting different languages at start.
        //  Therefore there is no collision so the users can not choose the same langauge
        let scenario1 = XCUIApplication()
        
        if scenario1.buttons["START"].isSelected {
            
            //  then test this allert display the message to the user properlu
            XCTAssertTrue(scenario1.alerts["Choose different languages"].buttons["OKAY"].exists)
        }
        
        
        //  given scenario 2
        //  where thee user select a different language to learn, in this case spanish.
        //  I am testing the next UI element which is an alert confirming the language and
        //  giving the chance to restart the vocabulary if selecting the same languages again.
        let scenario2 = XCUIApplication()
        
        if scenario2.otherElements.containing(.staticText, identifier:"Your language").children(matching: .picker).element(boundBy: 0).pickerWheels["Spanish"].isSelected {
            
            
            //  then test these alert is displaying correctly
            XCTAssertTrue(scenario2.buttons["START"].exists)
            XCTAssertTrue(scenario2.alerts["Restart App"].buttons["Yes"].exists)
            XCTAssertTrue(scenario2.alerts["Restart App"].buttons["No"].exists)
        }
    }
    
    func testSecondScreen() {
        
        //  given scenario 1
        //  where user access the second screen. This test is crucial as if it goes throught
        //  it means more screens can have UI elements which exist when previous required
        //  UI elements are selected. I could also test if any UI elements where enabled.
        //  But i did not see the point as all of them are enabled by default.
        let scenario1 = XCUIApplication()
        
        if scenario1.otherElements.containing(.staticText, identifier:"Your language").children(matching: .picker).element(boundBy: 0).pickerWheels["Spanish"].isSelected {
            if scenario1.buttons["START"].isSelected{
                if scenario1.alerts["Restart App"].buttons["No"].isSelected {
                    if scenario1.textFields["Add a new word"].isSelected{

                        //  then test this essential UI elements exist
                    XCTAssertTrue(scenario1.buttons["save"].exists)
                    XCTAssertTrue(scenario1.alerts["Translation"].buttons["Add"].exists)
                    }
                }
            }
        }
    }
}
