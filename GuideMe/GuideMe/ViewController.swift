//
//  ViewController.swift
//  GuideMe
//
//  Created by Leke Abolade on 31/01/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!

    var lastMessage = "Welcome to Guide Me"
    
    var speech = Speech()
    
    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.black
    
        
        self.distanceReading.text = lastMessage
        self.textToSpeech(string: lastMessage)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        whenInUse(status: status)
    }

    
    func whenInUse(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            montoringAvailable()
        }
    }
    
    func montoringAvailable() {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            rangingAvailable()
        }
    }
    
    func rangingAvailable() {
        if CLLocationManager.isRangingAvailable() {
            startScanning()
        }
    }

    
    func startScanning() {
        guard let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") else {
            print("UUID is nil")
            return
        }
    
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Region")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
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
        setTextLabelAndSpeak(text: unwrappedMessage)
    }
    
    func enterFromTrain(beacon: CLBeacon) {
        let number = beacon.minor.intValue
        print(number)
        guard let unwrappedMessage = fromPlatform[number] else {
            print ("I don't recognise this beacon")
            return
        }
        setTextLabelAndSpeak(text: unwrappedMessage)
    }
    
    var lastBeacon : Int = 0
    
    func findBeacons(beacons: [CLBeacon]) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            if beacon.minor.intValue < lastBeacon || beacon.minor.intValue == 65159 {
                enterFromTrain(beacon: beacon)
                lastBeacon = beacon.minor.intValue
            } else if beacon.minor.intValue > lastBeacon {
                enterFromRoad(beacon: beacon)
                lastBeacon = beacon.minor.intValue
            } else if beacon.minor.intValue == lastBeacon {
                setTextLabelAndSpeak(text: lastMessage)
            } else {
                setTextLabelAndSpeak(text: "I'm a bit confused.")
            }
        } else {
            setTextLabelAndSpeak(text: "There are no beacons in this area")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        beacons.sorted {$0.accuracy < $1.accuracy}
        findBeacons(beacons: beacons)
    }
    
    
    @IBOutlet weak var textView: UILabel!

    
    func setTextLabelAndSpeak(text: String) {
        self.distanceReading.text = text
        onlySpeakOnce()
        self.lastMessage = self.distanceReading.text!
    }
    
    func onlySpeakOnce() {
        if (self.lastMessage != self.distanceReading.text) {
            speech.playSound()
            self.textToSpeech(string: self.distanceReading.text!)
        }
    }
    
    
    func textToSpeech(string: String) {
        speech.textToSpeechSettings(string: string)
    }
    
}

