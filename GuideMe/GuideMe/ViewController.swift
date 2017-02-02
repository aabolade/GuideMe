//
//  ViewController.swift
//  GuideMe
//
//  Created by Leke Abolade on 31/01/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!

    var lastMessage = "Welcome to Guide Me"
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "Guide me has begun scanning")

    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.black
    
        
        self.distanceReading.text = lastMessage
        self.textToSpeech(string: lastMessage)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        guard let uuid = UUID(uuidString: "03AFA697-1AB3-45F6-9D32-47CFAE1D6B63") else {
            print("UUID is nil")
            return
        }
    
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Region")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    
    func showFirstBeacon(beacon: CLBeacon) {
        switch beacon.minor {
        case 1:
            setTextLabelAndSpeak(text: "Louisa")
        case 2:
            setTextLabelAndSpeak(text: "Courtney")

        default:
           setTextLabelAndSpeak(text: "There are no beacons in this area")
        }
    }
    
    func findBeacons(beacons: [CLBeacon]) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            showFirstBeacon(beacon: beacon)
        } else {
            setTextLabelAndSpeak(text: "There are no beacons in this area")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        beacons.sorted {$0.accuracy < $1.accuracy}
        findBeacons(beacons: beacons)
    }
    
    
    @IBOutlet weak var textView: UILabel!

    func textToSpeechSettings(string: String) {
        let synth = AVSpeechSynthesizer()
        var myUtterance = AVSpeechUtterance(string: "")
        myUtterance = AVSpeechUtterance(string: string)
        myUtterance.rate = 0.3
        myUtterance.volume = 1.0
        synth.speak(myUtterance)
    }
    
    func setTextLabelAndSpeak(text: String) {
        self.distanceReading.text = text
        if (self.lastMessage != self.distanceReading.text) {
            self.textToSpeech(string: self.distanceReading.text!)
        }
        self.lastMessage = self.distanceReading.text!
    }
    
    func textToSpeech(string: String) {
        textToSpeechSettings(string: string)
    }
    
}

