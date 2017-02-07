//
//  Beacons.swift
//  GuideMe
//
//  Created by Courtney Osborn on 06/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation
import CoreLocation

class UsingBeacons {
    
    //var viewController = ViewController()
    
    var lastMessage = "Welcome to Guide Me"
    
    var speech = Speech()
    
    
        func startScanning() {
            print("start scanning")
        guard let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") else {
            print("UUID is nil")
            return
        }
        
       let locationManager = ViewController().locationManager
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Region")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
    }
    
    var fromRoad: [Int: String] = [
        1: "Entering Algate station",
        41693: "Stairs ahead, go down 56 steps",
        49281: "Turn Left",
        65159:"You are now on the Algate platform"
    ]
    
    var fromPlatform: [Int: String] = [
        65159:  "You are now on the Algate platform",
        49281:  "Turn Right",
        41693: "Stairs ahead, go up 56 steps",
        1: "You are exiting Algate station"
    ]

    func enterFromRoad(beacon: CLBeacon) {
        let number = beacon.minor.intValue
        print(number)
        guard let unwrappedMessage = fromRoad[number] else {
            print ("I don't recognise this beacon")
            return
        }
        ViewController().setTextLabelAndSpeak(text: unwrappedMessage)
    }
    
    func enterFromTrain(beacon: CLBeacon) {
        let number = beacon.minor.intValue
        print(number)
        guard let unwrappedMessage = fromPlatform[number] else {
            print ("I don't recognise this beacon")
            return
        }
        ViewController().setTextLabelAndSpeak(text: unwrappedMessage)
    }
    
    var lastBeacon : Int = 0
    
    
    func findBeacons(beacons: [CLBeacon]) {
        print("findBeacons")
        if beacons.count > 0 {
            let beacon = beacons[0]
            sortDirection(beacon: beacon)
        } else {
            ViewController().setTextLabelAndSpeak(text: "There are no beacons in this area")
        }
    }
    
    func sortDirection(beacon: CLBeacon) {
        if beacon.minor.intValue < lastBeacon || beacon.minor.intValue == 65159 {
            enterFromTrain(beacon: beacon)
            lastBeacon = beacon.minor.intValue
        } else if beacon.minor.intValue > lastBeacon {
            enterFromRoad(beacon: beacon)
            lastBeacon = beacon.minor.intValue
        } else if beacon.minor.intValue == lastBeacon {
            ViewController().setTextLabelAndSpeak(text: lastMessage)
        } else {
            ViewController().setTextLabelAndSpeak(text: "I'm a bit confused.")
        }
        
    }
    
    func textToSpeech(string: String) {
        speech.textToSpeechSettings(string: string)
    }


}
