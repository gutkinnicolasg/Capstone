//
//  JumpRegisterationViewController.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 3/5/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import UIKit

class JumpRegistratonViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //Link the text fields to variables
    @IBOutlet weak var jumpNumTxtField: UITextField!
    @IBOutlet weak var jumpTypeTxtField: UITextField!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var aircraftTxtField: UITextField!
    @IBOutlet weak var rigTxtField: UITextField!
    @IBOutlet weak var canopyTxtField: UITextField!
    @IBOutlet weak var exitAltTxtField: UITextField!
    @IBOutlet weak var depAltTxtField: UITextField!
    @IBOutlet weak var sWindTxtField: UITextField!
    @IBOutlet weak var dTargetTxtField: UITextField!
    @IBOutlet weak var wingsuitSwitch: UISwitch!
    @IBOutlet weak var cutawaySwitch: UISwitch!
    
    //Takes care of turning jumpType into a Picker View
    var jumptypes = ["Student", "Tandem", "Sport", "B.A.S.E"]
    var picker = UIPickerView()
    
    //required methods for picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jumptypes.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        jumpTypeTxtField.text = jumptypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return jumptypes[row]
    }
    
    //Takes care of turning date into a DatePicker View
    let datePicker = UIDatePicker()
    
    //function to create a DatePicker
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        dateTxtField.inputAccessoryView = toolbar
        dateTxtField.inputView = datePicker
    }
    
    //done button for the DatePicker View
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: datePicker.date)
        dateTxtField.text = "\(dateString)"
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
        picker.dataSource = self
        jumpTypeTxtField.inputView = picker
        createDatePicker()
        self.navigationItem.title = "Jump Registration"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Action for Submit Button
    @IBAction func submitButton(_ sender: Any) {
        //Initializes variables with what is entered in text fields
        let jumpNum = jumpNumTxtField.text
        let jumpType = jumpTypeTxtField.text
        let date = dateTxtField.text
        let location = locationTxtField.text
        let aircraft = aircraftTxtField.text
        let rig = rigTxtField.text
        let canopy = canopyTxtField.text
        let exitAlt = exitAltTxtField.text
        let depAlt = depAltTxtField.text
        let sWind = sWindTxtField.text
        let dTarget = dTargetTxtField.text
        let wingsuit = wingsuitSwitch.isOn
        let cutaway = cutawaySwitch.isOn
        
        //gets username from the current session user
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "userNameKey")
        
        //Store the value into MAMP
        let myUrl = URL(string: "http://localhost:8888/registration/jumpRegister.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        //a String of what will be sent to the 'jumpLog' table
        let serverString = "username=\(username!)&jumpNum=\(jumpNum!)&jumpType=\(jumpType!)&date=\(date!)&location=\(location!)&aircraft=\(aircraft!)&rig=\(rig!)&canopy=\(canopy!)&exitAlt=\(exitAlt!)&depAlt=\(depAlt!)&sWind=\(sWind!)&dTarget=\(dTarget!)&wingsuit=\(wingsuit)&cutaway=\(cutaway)"
        
        request.httpBody = serverString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            //if there's an error print it out
            if(error != nil) {
                print("error: \(String(describing: error))")
                return
            }
            //grab the json messages from the php file
            let json =  try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
            //print out the message
            if let parseJSON = json {
                
                let message = parseJSON["message"] as? String
                let status = parseJSON["status"] as? String
                print("result: \(message!)")
                
                //if Error message pops up why
                if (status! != "Success:") {
                    DispatchQueue.main.async {
                        let myMessage = UIAlertController(title: status, message: message, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                        myMessage.addAction(okAction)
                        self.present(myMessage, animated:true, completion: nil)
                    }
                }
                   
                //else Success message pops up
                else
                {
                    DispatchQueue.main.async {
                        let myMessage = UIAlertController(title: status, message: message, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                        {
                           action in self.performSegue(withIdentifier: "back2Logbook", sender: nil)
                        }
                        myMessage.addAction(okAction)
                        self.present(myMessage, animated:true, completion: nil)
                    }
                }
            }
        }
        task.resume();
    }
}


 


