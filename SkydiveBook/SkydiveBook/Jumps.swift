//
//  Jumps.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 4/9/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import Foundation

class Jumps {
    //Initializes variables
    var jumpNum: String
    var jumpType: String
    var date: String
    var location: String
    var aircraft: String
    var rig: String
    var canopy: String
    var exitAlt: String
    var depAlt: String
    var sWind: String
    var dTarget: String
    var wingsuit: String
    var cutaway: String
    
    //Initialize them with values
    init(json: [String:Any] ) {
        self.jumpNum = json["jumpNum"] as! String
        self.jumpType = json["jumpType"] as! String
        self.date = json["date"] as! String
        self.location = json["location"] as! String
        self.aircraft = json["aircraft"] as! String
        self.rig = json["rig"] as! String
        self.canopy = json["canopy"] as! String
        self.exitAlt = json["exitAlt"] as! String
        self.depAlt = json["depAlt"] as! String
        self.sWind = json["sWind"] as! String
        self.dTarget = json["dTarget"] as! String
        self.wingsuit = json["wingsuit"] as! String
        self.cutaway = json["cutaway"] as! String
    }
    
    //More initializing
    init(jumpNum: String, jumpType: String, date: String, location: String ,aircraft: String, rig: String, canopy: String, exitAlt: String, depAlt: String, sWind: String, dTarget: String, wingsuit: String, cutaway: String) {
        self.jumpNum = jumpNum
        self.jumpType = jumpType
        self.date = date
        self.location = location
        self.aircraft = aircraft
        self.rig = rig
        self.canopy = canopy
        self.exitAlt = exitAlt
        self.depAlt = depAlt
        self.sWind = sWind
        self.dTarget = dTarget
        self.wingsuit = wingsuit
        self.cutaway = cutaway
    }
}

