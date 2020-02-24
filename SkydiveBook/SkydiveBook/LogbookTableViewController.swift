//
//  LogbookTableViewController.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 4/9/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import UIKit

class LogbookTableViewController: UITableViewController {
    //Initialize jump array
    var jumps = [Jumps]()
    
    func loadJumps() {
        //get username from the session
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "userNameKey")
        
        //Grab storred values from MAMP
        let myUrl = URL(string: "http://localhost:8888/registration/logbookCell.php")
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
            let json =  try? JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            //print out the message
            if let parseJSON = json {
                //grab the json messages from the php file
                let results = parseJSON["results"] as! [[String: Any]]
                //print out the message
                for result in results {
                    self.jumps.append(Jumps(json: result))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJumps()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jumps.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LogbookTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LogbookTableViewCell  else {
                fatalError("The dequeued cell is not an instance of logbooktableviewcell.")
            }
        let jump = jumps[indexPath.row]
        // Configure the cell...
        cell.date.text = jump.date
        cell.jumpNum.text = jump.jumpNum
        cell.location.text = jump.location
        return cell
    }
}
