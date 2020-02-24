//
//  WeatherViewController.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 4/4/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UISearchBarDelegate {
    //Link the text fields to variables
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var todayTemp: UILabel!
    @IBOutlet var todayWind: UILabel!
    @IBOutlet var tomorrowTemp: UILabel!
    @IBOutlet var tomorrowWind: UILabel!
    @IBOutlet var todayImg: UIImageView!
    @IBOutlet var tomorrowImg: UIImageView!
    @IBOutlet var todaySummary: UITextView!
    @IBOutlet var tomorrowSummary: UITextView!
    
    
    var forecastData = [Weather]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
        
    }
    
    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            let today = weatherData[0]
                            let tomorrow = weatherData[1]
                            DispatchQueue.main.async {
                                self.todayTemp?.text = String(format:"%.1f °F", today.temperature)
                                self.tomorrowTemp?.text = String(format:"%.1f °F", tomorrow.temperature)
                                self.todayWind?.text = String(format:"%.1f mph wind speeds",today.windSpeed)
                                self.tomorrowWind?.text = String(format:"%.1f mph wind speeds", tomorrow.windSpeed)
                                self.todaySummary?.text = String(today.summary)
                                self.tomorrowSummary?.text = String(tomorrow.summary)
                                self.todayImg?.image = UIImage(named: today.icon + ".png")
                                self.tomorrowImg?.image = UIImage(named: tomorrow.icon + ".png")
                            }
                        }
                        
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
