//
//  iOS_AssignmentTests.swift
//  iOS-AssignmentTests
//
//  Created by Carlos Roldan on 27/11/2018.
//  Copyright © 2018 Carlos Roldan. All rights reserved.
//

import XCTest


class iOS_AssignmentTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScore() {
        //  1. given the following parameters = score and score message
        let points = 70
        let messages = ["Well done! You have not failed even once. Keep up your progress.",
                      "Your progress is noticeable. You are close to pass the test without failing.",
                      "Your progress is slightly well. Carry on testing yourself to achieve the maximum points",
                      "There is always room for improvement. Progress is not made in one day, so keep testing yourself!"
                      ]
        
        var message = ""
        
        //  2. when the score meets a certain range of number or a number value
        if points == 70 {
            message = "Well done! You have not failed even once. Keep up your progress."
        } else if points < 50 && points > 70 {
            message = "Your progress is noticeable. You are close to pass the test without failing."
        } else if points < 30 && points > 50 {
            message = "Your progress is slightly well. Carry on testing yourself to achieve the maximum points"
        } else if points < 0 && points > 30 {
            message = "There is always room for improvement. Progress is not made in one day, so keep testing yourself!"
        } else {
            message = "Nice, keep up the test!"
        }
        
        //  3. then test if the score is equal to the message given
        XCTAssertEqual(message, messages[0])
    }
}
