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
    
    var usingBeacons = UsingBeacons()

    var lastMessage = "Welcome to Guide Me"
    
    //var speech = Speech()
    
    var beepSound = BeepSound()
    
    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.black
    
        
        self.distanceReading.text = lastMessage
        usingBeacons.textToSpeech(string: lastMessage)
        
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
            print("ESBDMKDOALDKLL************************")
            rangingAvailable()
        }
    }
    
    func rangingAvailable() {
        if CLLocationManager.isRangingAvailable() {
            print("Range Available.............................................")
            usingBeacons.startScanning()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        beacons.sorted {$0.accuracy < $1.accuracy}
        usingBeacons.findBeacons(beacons: beacons)
    }
    
    
    @IBOutlet weak var textView: UILabel!

    
    func setTextLabelAndSpeak(text: String) {
        self.distanceReading.text = text
        onlySpeakOnce()
        self.lastMessage = self.distanceReading.text!
    }
    
    func onlySpeakOnce() {
        if (self.lastMessage != self.distanceReading.text) {
            beepSound.playSound()
            usingBeacons.textToSpeech(string: self.distanceReading.text!)
        }
    }
    
    
}

