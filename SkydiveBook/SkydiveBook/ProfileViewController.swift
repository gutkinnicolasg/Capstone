//
//  ProfileViewController.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 4/11/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import UIKit

class ProfileViewController: UIViewController {
    //Link the text fields to variables
    @IBOutlet var name: UILabel!
    @IBOutlet var tJumps: UILabel!
    @IBOutlet var tSport: UILabel!
    @IBOutlet var tBase: UILabel!
    @IBOutlet var tTandem: UILabel!
    @IBOutlet var tStudent: UILabel!
    @IBOutlet var tCutaway: UILabel!
    @IBOutlet var tWingsuit: UILabel!
    @IBOutlet var tDistance: UILabel!
    @IBOutlet var tTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "CloudySky.jpg")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        //get username from the session
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "userNameKey")
        
        //Grab storred values from MAMP
        let myUrl = URL(string: "http://localhost:8888/registration/profilePage.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        //a String of what will be sent to the 'user' table
        let serverString = "username=\(username!)"
       
        request.httpBody = serverString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            //if there's an error print it out
            if(error != nil) {
                print("error: \(String(describing: error))")
                return
            }
            //grab the json messages from the php file
            let json =  try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
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
                
                //else Successful stuff happens
                else
                {
                    DispatchQueue.main.async {
                        let results = parseJSON["results"]!
                        self.name.text = "\(results["name"]!!)"
                        self.tJumps.text = "\(results["tJumps"]!!)"
                        self.tSport.text = "\(results["tSport"]!!)"
                        self.tBase.text = "\(results["tBase"]!!)"
                        self.tTandem.text = "\(results["tTandem"]!!)"
                        self.tStudent.text = "\(results["tStudent"]!!)"
                        self.tCutaway.text = "\(results["tCutaway"]!!)"
                        self.tWingsuit.text = "\(results["tWingsuit"]!!)"
                        self.tDistance.text = "\(results["tFFD"]!!)"
                        self.tTime.text = "\(results["tFFT"]!!)"
                        print(results)
                    }
                }
            }
        }
        task.resume();
    }
    
    //Action for logout button
    @IBAction func LogOutButton(_ sender: Any) {
        //clears username value from the session
        UserDefaults.standard.removePersistentDomain(forName: "userNameKey")
        self.performSegue(withIdentifier: "Logout", sender: nil)
    }
    

}
