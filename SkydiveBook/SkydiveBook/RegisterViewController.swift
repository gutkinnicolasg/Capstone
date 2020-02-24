//
//  RegisterViewController.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 3/5/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import UIKit

class RegisterViewController: UIViewController {
    //Link the text fields to variables
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet var retypePassTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Segue to Login Page
    @IBAction func back2Login(_ sender: UIButton) {
           self.performSegue(withIdentifier: "back2Login", sender: nil)
    }
    
    //Action for Submit Button
    @IBAction func submitButton(_ sender: UIButton) {
        //Initializes variables with what is entered in text fields
        let firstName = firstNameTxtField.text
        let lastName = lastNameTxtField.text
        let username = usernameTxtField.text
        let password = passwordTxtField.text
        let retypePass = retypePassTxtField.text
        
        //if Passwords are different
        if (retypePass != password) {
            DispatchQueue.main.async {
                let myMessage = UIAlertController(title: "Error:", message: "Passwords Don't Match", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                myMessage.addAction(okAction)
                self.present(myMessage, animated:true, completion: nil)
            }
        }
            
        else {
            //Store the value into MAMP
            let myUrl = URL(string: "http://localhost:8888/registration/userRegister.php")
            var request = URLRequest(url: myUrl!)
            request.httpMethod = "POST"
            
            //a String of what will be sent to the 'user' table
            let serverString = "firstName=\(firstName!)&lastName=\(lastName!)&username=\(username!)&password=\(password!)"
            
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
                    print("result: \(status!)")
                    
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
                                 action in self.performSegue(withIdentifier: "back2Login", sender: nil)
                            }
                            myMessage.addAction(okAction)
                            self.present(myMessage, animated:true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
