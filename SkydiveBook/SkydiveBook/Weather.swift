//
//  Weather.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 4/15/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import Foundation
import CoreLocation

struct Weather {
    //Initializes variables
    let summary:String
    let icon:String
    let temperature:Double
    let windSpeed:Double
    
    //Initialize
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String
            else {
                fatalError("Missing the summary")
            }
        guard let icon = json["icon"] as? String
            else {
                fatalError("Missing the icon")
            }
        guard let temperature = json["temperatureHigh"] as? Double
            else {
                fatalError("Missing the temperature")
            }
        guard let windSpeed = json["windSpeed"] as? Double
            else {
                fatalError("Missing the wind speed")
            }
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.windSpeed = windSpeed
    }
    
    //url for my darksky development
    static let basePath = "https://api.darksky.net/forecast/4954ff2ee8888acb382b7edcc97f5a08/"
    
    //func for forecast
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data:Data?, response:URLResponse?, error:Error?) in
            
            //an array of the forecast
            var forecast:[Weather] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        //select the daily option
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            //get the data from daily
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                //loop through all the datapoints for the next 7 days
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        //add data to the array
                                        forecast.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                //satisfies the @escaping call in the method header
                completion(forecast)
            }
        }
        task.resume()
    }
}


