//
//  HomeViewController.swift
//  iOS-Assignment
//
//  Created by Carlos Roldan on 16/11/2018.
//  Copyright © 2018 Carlos Roldan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  instantiate UI variables
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    //  declare dictionary of words
    var dictionary        = [String: String]()
    //  declare inverse dictionary of words
    var inverseDictionary = [String: String]()

    var numberOfTests         = 0

    
    //  function to print the number of rows within the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }
    
    //   fucntion to add cells in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        let key   = Array(self.dictionary.keys)[indexPath.row]
        let value = Array(self.dictionary.values)[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = key + " = " + value
        
        return cell
    }
    //  main function tha is executed when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  call dependencies to have a custom table view
        tableView.delegate = self
        tableView.dataSource = self
        
        //  retrieve data stored in JSON file
        retrieveFromJsonFile()
        
    }

    func saveInJsonFile() {
        // Get the url of Disctionary.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("Dictionary.json")
        
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            try data.write(to: fileUrl, options: [])
            
        } catch {
            print(error)
        }
    }
    
    func retrieveFromJsonFile() {
        // Get the url of Disctionary.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("Dictionary.json")
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let readedArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String:String] else { return }
            print(readedArray)
            dictionary = readedArray
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameVCSegue" {
            let destinationVC = segue.destination as! GameViewController
            destinationVC.translatingDictionary = dictionary
            destinationVC.reverseDictionary = inverseDictionary

        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Number of finished tests: " + String(numberOfTests)

    }
    
    //  Function to allow the user delete words by simply using a gesture
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //  if the gesture is for removing
        if editingStyle == .delete {
            //  remove the word from the array
            dictionary.removeValue(forKey: Array(self.dictionary.keys)[indexPath.row])
            //  remove the dell from the table view with a fade animatiom
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
    }
    
    

    //  event handler for the save button
    fileprivate func createDefaultAlert(_ title: String, _ message: String) {
        //  create an notification alert
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert )
        
        //  create a notification button for the alert
        let ok = UIAlertAction.init(title: "Okay", style: .cancel, handler: nil  )
        
        //  add the alert button to the notification alert
        alert.addAction(ok)
        
        //  display the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
       //  if no words are typed
        if input.text == "" {
            createDefaultAlert("No words entered", "Please type a word to save it into your vocabulary database.")
            
            //  if a word is typed
        } else {
            //  add the word in the dictionary as key + as value
            self.dictionary.updateValue(input.text!, forKey: input.text!)

            //  1. Create the alert controller.
            let alert = UIAlertController(title: "Translation", message: "Enter the meaning of the word " + input.text!, preferredStyle: .alert)
            
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            
            //  2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.placeholder = self.input.text! + " in the opposite language"
            }
            
            alert.addAction(cancel)
            
            //  3. Grab the value from the text field, and stores it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                //  Force unwrapping because we know it exists.
                let textField = alert!.textFields![0]

               
                //  add value to key for dictionary
                self.dictionary.updateValue(textField.text!.lowercased(), forKey: self.input.text!)
                
                //  add inverse value to key in dictionary
                self.inverseDictionary.updateValue(self.input.text!, forKey: textField.text!.lowercased())
                
                // save into JSON file
                self.saveInJsonFile()
                
                //  refresh table view
                self.tableView.reloadData()
                
                //  Leave textfield empty
                self.input.text = ""
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        saveInJsonFile()
        if dictionary.isEmpty {
            createDefaultAlert("No words in vocabulary", "Please make sure you have entered a few words to use the testing game")
        }
        performSegue(withIdentifier: "toGameVCSegue", sender: nil)
    }
}
