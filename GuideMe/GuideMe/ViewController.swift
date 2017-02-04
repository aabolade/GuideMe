//
//  ViewController.swift
//  GuideMe
//
//  Created by Leke Abolade on 31/01/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class ViewController: UIViewController, CLLocationManagerDelegate, SettingsViewControllerDelegate {
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsViewController" {
            let settingsViewController = segue.destination as? SettingsViewController
//            let navigationController = segue.destination as? UINavigationController
//            let settingsViewController = navigationController?.topViewController as? SettingsViewController
            
            if let viewController = settingsViewController {
                viewController.delegate = self
            }
        }
    }
    
    func makeChangesToFont(size: Int) {
        updateFontSize(fontSize: size)
    }
    
    func updateFontSize(fontSize : Int) {
        if (self.distanceReading.font.pointSize > 20) {
            self.distanceReading.font = UIFont(name: self.distanceReading.font.fontName, size: CGFloat(fontSize))
        }
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
    
    func showFirstBeacon(beacon: CLBeacon) {
        switch beacon.minor {
        case 1:
            setTextLabelAndSpeak(text: "Phone")
        case 65159:
            setTextLabelAndSpeak(text: "Beacon 3")
        case 41693:
            setTextLabelAndSpeak(text: "Beacon 1")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        case 49281:
            setTextLabelAndSpeak(text: "Beacon 2")
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
    
    func increaseFontSize () {
        let text = self.distanceReading
        text?.font = UIFont(name: (text?.font.fontName)!, size: (text?.font.pointSize)! + 10)
    }
    
    func decreaseFontSize () {
        let text = self.distanceReading
        
        if (Int((text?.font.pointSize)!) > 20) {
           text?.font = UIFont(name: (text?.font.fontName)!, size: (text?.font.pointSize)! - 10)
        }

    }
    
    @IBAction func IncreaseFontSize(_ sender: UIButton) {
        increaseFontSize()

    }
    
    @IBAction func DecreaseFontSize(_ sender: UIButton) {
        decreaseFontSize()
    }
}

