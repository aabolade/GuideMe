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
    
    func enterFromRoad(beacon: CLBeacon) {
        switch beacon.minor {
        case 1:
            setTextLabelAndSpeak(text: "Entering Algate station")
        case 65159:
            setTextLabelAndSpeak(text: "Stairs ahead, go down 56 steps")
        case 41693:
            setTextLabelAndSpeak(text: "Turn Left")
        case 49281:
            setTextLabelAndSpeak(text: "You are now on the Algate platform")
        default:
           setTextLabelAndSpeak(text: "There are no beacons in this area")
        }
    }
    
    func enterFromTrain(beacon: CLBeacon) {
        switch beacon.minor {
        case 49281:
            setTextLabelAndSpeak(text: "You are now on the Algate platform")
        case 41693:
            setTextLabelAndSpeak(text: "Turn Right")
        case 65159:
            setTextLabelAndSpeak(text: "Stairs ahead, go up 56 steps")
        case 1:
            setTextLabelAndSpeak(text: "You are exiting Algate station")
        default:
            setTextLabelAndSpeak(text: "There are no beacons in this area")
        }

    }
    
    func findBeacons(beacons: [CLBeacon]) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            enterFromRoad(beacon: beacon)
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

