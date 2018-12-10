//
//  ViewController.swift
//  iOS-Assignment
//
//  Created by Carlos Roldan on 16/11/2018.
//  Copyright © 2018 Carlos Roldan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate,
UIPickerViewDataSource {
    //  instantiate array of languages
    var languageArray   = [String]()
    var new             = false;
    var chosenLanguage  = ""
    var chosenForeignLanguage = ""
    
    //  instantiate UI variables
    @IBOutlet weak var languageChooser: UIPickerView!
    @IBOutlet weak var foreignLanguageChooser: UIPickerView!
    @IBOutlet weak var addLangButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    //  function to return the number of components from the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //  function to return the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray.count
    }
    
    //  function to return the titles for the each row in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageArray[row]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localName = UserDefaults.standard.string(forKey: "new")
        
        if localName == "" {
            new = true
        }

        
        //  dependencies to delegate and use data source from the picker view
        languageChooser.dataSource = self
        languageChooser.delegate = self
        foreignLanguageChooser.dataSource = self
        foreignLanguageChooser.delegate = self
        
        //  insert langauges to the array
        languageArray.append("Spanish")
        languageArray.append("English")
        languageArray.append("Chineese")
        languageArray.append("French")
        languageArray.append("German")
        languageArray.append("Arabic")
        languageArray.append("Polish")
        languageArray.append("Russian")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeVCSegue" {
            //  send values to next screen
            let destinationVC = segue.destination as! HomeViewController

            if new {
                destinationVC.dictionary.removeAll()
                destinationVC.saveInJsonFile()
            }
        }
    }
    
    //  event handler for the save button
    @IBAction func startAction(_ sender: Any) {
        var isSameLanguage = false;
        //  select native language
        chosenLanguage = languageArray[languageChooser.selectedRow(inComponent: 0)]
        //  select foreign language
        chosenForeignLanguage = languageArray[foreignLanguageChooser.selectedRow(inComponent: 0)]
        
        if chosenLanguage == chosenForeignLanguage {
            //  if same language is chosen notify the user
            isSameLanguage = true
            
            //  create an notification alert
            let alert = UIAlertController.init(title: "Choose different languages", message: "You have selected " + chosenLanguage + " and " + chosenForeignLanguage + " as a new language to learn or improve. Please select different languages" , preferredStyle: .alert )
            
            //  create notification button for the alert
            let ok = UIAlertAction.init(title: "OKAY", style: .cancel, handler: nil)
            
            //  add the alert button to the notification alert
            alert.addAction(ok)
            
            //  display the alert to the user
            self.present(alert, animated: true, completion: nil)
        }
        
        if !isSameLanguage {
            
            if new {
                let alert = UIAlertController.init(title: "Confirm selection", message: "You have selected " + chosenLanguage + " and " + chosenForeignLanguage + " as a new language to learn or improve. Should we start?" , preferredStyle: .alert )
                
                //  create notification button for the alert
                let ok = UIAlertAction.init(title: "YES", style: .cancel, handler:{ (UIAlertAction) in
                    
                    //  remember is not new for future decissions
                    UserDefaults.standard.set("Not_New", forKey: "new")
                    
                    //  perform actions when clicked yes
                    self.performSegue(withIdentifier: "toHomeVCSegue", sender: nil)
                })
                let no = UIAlertAction.init(title: "NO", style: .cancel, handler: nil)
                
                //  add the alert buttons to the notification alert
                alert.addAction(ok)
                alert.addAction(no)
                
                //  display the alert to the user
                self.present(alert, animated: true, completion: nil)
                
            } else {
                //  create an notification alert
                let alert = UIAlertController.init(title: "Restart App", message: "Selecting a different language will delete the previous vocabulary. Are you sure to continue?", preferredStyle: .alert )
                
                //  create notification buttons for the alert
                let yes = UIAlertAction.init(title: "Yes", style: .default, handler: { (UIAlertAction) in
                    
                    //  delete values and start again
                    self.new = true;
                    
                    //  perform actions when clicked yes
                    self.performSegue(withIdentifier: "toHomeVCSegue", sender: nil)
                })
                
                let no = UIAlertAction.init(title: "No", style: .default, handler: { (UIAlertAction) in
                    
                    //  perform actions when clicked yes
                    self.performSegue(withIdentifier: "toHomeVCSegue", sender: nil)
                })
                
                //  add the alert button to the notification alert
                alert.addAction(yes)
                alert.addAction(no)
                
                //  display the alert to the user
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        //  perform segue directly
        self.performSegue(withIdentifier: "toHomeVCSegue", sender: nil)
    }
    
    
    @IBAction func addLangAction(_ sender: Any) {
        //  create an notification alert
        let alert = UIAlertController.init(title: "Add Language", message: "Please type your languages below.", preferredStyle: .alert )
         
        alert.addTextField { (textField) in
            textField.placeholder = "Type your language here.."
            self.chosenLanguage = textField.text!
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Type your desired language here.."
            self.chosenForeignLanguage = textField.text!
        }
        
        //  create notification buttons for the alert
        let next = UIAlertAction.init(title: "Next", style: .default, handler: { (UIAlertAction) in
            
            //  perform actions when clicked yes
            self.performSegue(withIdentifier: "toHomeVCSegue", sender: nil)
        })
        
        let no = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        
        //  add the alert button to the notification alert
        alert.addAction(next)
        alert.addAction(no)
        
        //  display the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
}
