//
//  GameViewController.swift
//  iOS-Assignment
//
//  Created by Carlos Roldan on 16/11/2018.
//  Copyright © 2018 Carlos Roldan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //  declare UI variables
    @IBOutlet weak var mainWordLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var initMessage: UITextView!
    @IBOutlet weak var initHintMessage: UITextView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    //  declare arrays
    var translatingDictionary = [String:String]()
    var randomWords           = [String]()
    var reverseDictionary     = [String:String]()
    var challengeArray        = [String]()
    
    //  declare global strings
    var currentWord : String    = ""
    var answer      : String    = ""

    //  declare global counters - INT
    var points  : Int    = 0
    var counter : Int    = 0
    var rounds  : Int    = 1

    //  devlare
    var isFinished = false
    
    //  Function to load the winning state
    fileprivate func winState() {
        //  1. Create the alert controller.
        let alert = UIAlertController(title: "Nice", message: "Nice, keep going to know how well you do", preferredStyle: .alert)
        
        //  2. Create alert action.
        let cancel = UIAlertAction.init(title: "Horray!", style: .default, handler:{ (UIAlertAction) in
            
            //   Winning view + settings
            self.rounds = self.rounds + 1
            self.progressLabel.text = String(self.rounds) + "/10"
            self.hintsLabel.text = "Hints: " + String(self.counter)
            self.calculatePoints()
            self.initMessage.isHidden = true
            self.initHintMessage.isHidden = true
            self.textInput.text = ""
            self.isFinished = false
            self.currentWord = self.randomWords.randomElement()!
            self.mainWordLabel.text = self.currentWord
            self.answer = self.translatingDictionary[self.currentWord]!
            self.counter = 0
            self.hint.text = self.populateChallente()
            //  if game has reached to 10 rounds
            if self.rounds == 10 {
                self.nextButton.titleLabel?.text = "END"
            }
        })
        
        //  3. Add action to the alert.
        alert.addAction(cancel)
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    //  function to calculate points for the user
    fileprivate  func calculatePoints(){
        if counter > 1 && counter < 4  {
            points = points + 2
        } else if counter == 1{
            points = points + 5
        } else if counter == 0 || counter == -1{
            points = points + 7
        } else {
            points = points + 0
        }
        //  print the points to the user
        pointsLabel.text = "Points: " + String(points)
    }
    
    //  function to populate character as hints each iteration
    //  maximum configuration of 8 iterations
    fileprivate func populateCharacters(_ message: inout String) {
        if (counter == 0) {
            message = answer[0]
        } else if (counter == 1){
            message = answer[0] + answer[1]
            
        }else if (counter == 2){
            message = answer[0] + answer[1] + answer[2]
            
        }else if (counter == 3){
            message = answer[0] + answer[1] + answer[2] + answer[3]
            
        }else if (counter == 4){
            message = answer[0] + answer[1] + answer[2] + answer[3] + answer[4]
            
        }else if (counter == 5){
            message = answer[0] + answer[1] + answer[2] + answer[3] + answer[4] + answer[5]
            
        }else if (counter == 6){
            message = answer[0] + answer[1] + answer[2] + answer[3] + answer[4] + answer[5] + answer[6]
            
        }else if (counter == 7){
            message = answer[0] + answer[1] + answer[2] + answer[3] + answer[4] + answer[5] + answer[6] + answer[7]
            
        }else if (counter == 8){
            message = answer[0] + answer[1] + answer[2] + answer[3] + answer[4] + answer[5] + answer[6] + answer[7] + answer[8]
            
        }else{
            counter = 0
        }
    }
    
    //   function to create the challenge including the hint word
    func populateChallente() -> String {
        var message = ""
        
        repeat {
            if ( hint.text == answer){
                isFinished = true
                winState()
            
                break
            }
            populateCharacters(&message)
        } while (isFinished);
        
        // return hint
        return message
    }
    
    //  main view function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initHintMessage.isEditable = false
        initMessage.isEditable = false
        
        //  for each word in the dictionary populate the array of keys
        for key in translatingDictionary.keys{
            randomWords.append(key)
        }
        
        //  populate initial answer + current testing word
        currentWord = randomWords.randomElement()!
        answer = translatingDictionary[currentWord]!
        mainWordLabel.text = currentWord
        
        //  bring the answer in format hint by showing characters
        hint.text = populateChallente()

    }
    
    //  prepare the segue to transmit data over views - number of tests
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endGameSegue" {
        let destinationVC = segue.destination as! HomeViewController
            destinationVC.numberOfTests = destinationVC.numberOfTests + 1
        }
    }
    
    //  function to load the end state to communicate the user how well has done
    fileprivate func endState() {
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
        }
        
        //  1. Create the alert controller.
        let alert = UIAlertController(title: "Stats", message: message, preferredStyle: .alert)
        
        //  2. Create alert action.
        let finishGame = UIAlertAction.init(title: "Horray!", style: .default, handler:{ (UIAlertAction) in
            self.performSegue(withIdentifier: "endGameSegue", sender: nil)
        })
        
        //  3. Add action to the alert.
        alert.addAction(finishGame)
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    //  funtion to load the error state - prints 1 more character/hint
    fileprivate func errorState() {
        counter = counter + 1
        hint.text = populateChallente()
        mainWordLabel.text = currentWord
        textInput.text = ""
        hintsLabel.text = "Hints: " + String(counter)
    }
    
    //  action function for the next button
    @IBAction func nextAction(_ sender: Any) {
        if textInput.text?.lowercased() == answer {
            //  if game has reached 10 rounds, finish it.
            if rounds == 10{
                endState()
            }else {
                //  keep playing
                winState()
            }
        } else{
            errorState()
        }
    }
}
