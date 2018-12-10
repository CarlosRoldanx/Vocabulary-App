//
//  Score.swift
//  iOS-AssignmentTests
//
//  Created by Carlos Roldan on 28/11/2018.
//  Copyright © 2018 Carlos Roldan. All rights reserved.
//

import Foundation

class Score: String {
    var points = 0
    
    
    func Score(_ score: inout Int) {
        points = score
    }
    
     func endState() -> String {
        var message = ""
        
        //  different messages based on the result of the test
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
        return message
    }
}
