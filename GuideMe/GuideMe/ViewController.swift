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
import Speech

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    
    var locationManager: CLLocationManager!

    var lastMessage = ""
    var platformMessage: String = ""
    var destinationMessage: String = ""
    let apiService = APIService()
    let speech = TextToSpeech()
    let vibrate = Vibrate()
    let beepMessage = MessageBeep()
    var receivedDestination: String = ""
    var textToSpeechOn: Bool = true
    var lastBeacon : Int = 0
    let beaconDirections = BeaconDirections()
    
    @IBOutlet weak var distanceReading: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.black
        
        if receivedDestination == "..." || receivedDestination == "" {
            self.destinationMessage = "Welcome to Guide Me"
        } else {
            self.destinationMessage = "Welcome to Guide Me. You are being guided to " + receivedDestination
        }
        self.distanceReading.text = destinationMessage
        self.textToSpeech(string: destinationMessage)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Location Manager Setup

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
    
    // MARK: Beacon Scanning

    func startScanning() {
        
        guard let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D") else {
            print("UUID is nil")
            return
        }

        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Region")

        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
 
    }
    
    func enterFromRoad(beaconNumber: Int) {

        guard let unwrappedMessage = beaconDirections.fromRoad[beaconNumber] else {
            print ("I don't recognise this beacon")
            return
        }
        
        if beaconNumber == 65159 {
            setTextLabelAndSpeak(text: (unwrappedMessage + getPlatformMessage()))
        } else if beaconNumber == 50300 {
            vibrate.vibrateForLeft()
            setTextLabelAndSpeak(text: unwrappedMessage)
        } else if beaconNumber == 50800 {
            vibrate.vibrateForRight()
            setTextLabelAndSpeak(text: unwrappedMessage)
        } else {
            setTextLabelAndSpeak(text: unwrappedMessage)
        }
    }
    
    func enterFromTrain(beaconNumber: Int) {
        guard let unwrappedMessage = beaconDirections.fromPlatform[beaconNumber] else {
            print ("I don't recognise this beacon")
            return
        }
        if beaconNumber == 50300 {
            vibrate.vibrateForLeft()
            setTextLabelAndSpeak(text: unwrappedMessage)
        } else if beaconNumber == 50800 {
            vibrate.vibrateForRight()
            setTextLabelAndSpeak(text: unwrappedMessage)
        } else {
            setTextLabelAndSpeak(text: unwrappedMessage)
        }
    }
    
    func findBeacons(beacons: [CLBeacon]) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            let beaconNumber = beacon.minor.intValue
            giveDirections(beaconNumber: beaconNumber)
        } else {
            setTextLabelAndSpeak(text: "There are no beacons in this area")
        }
    }
    
    func giveDirections(beaconNumber: Int) {
        if beaconNumber < lastBeacon || beaconNumber == 65159 && lastMessage == "" {
            enterFromTrain(beaconNumber: beaconNumber)
            lastBeacon = beaconNumber
        } else if beaconNumber > lastBeacon {
            enterFromRoad(beaconNumber: beaconNumber)
            lastBeacon = beaconNumber
        } else if beaconNumber == lastBeacon {
            setTextLabelAndSpeak(text: lastMessage)
        } else {
            setTextLabelAndSpeak(text: "I'm a bit confused.")
        }
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        var sortedBeacons = beacons.sorted {$0.accuracy < $1.accuracy}
        findBeacons(beacons: sortedBeacons)
    }
    
    @IBOutlet weak var textView: UILabel!

    
    func setTextLabelAndSpeak(text: String) {
        self.distanceReading.text = text
        onlySpeakOnce()
        self.lastMessage = self.distanceReading.text!
    }
    
    func onlySpeakOnce() {
        if (self.textToSpeechOn == true){
        if (self.lastMessage != self.distanceReading.text) {
            beepMessage.playSound()
            self.textToSpeech(string: self.distanceReading.text!)
        }
        }
    }
    
    func textToSpeech(string: String) {
        if (self.textToSpeechOn == true) {
            speech.textToSpeechSettings(string: string)
        }
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
    
    func getPlatformMessage() -> String {
        
        apiService.getLiveDepartures() { (departure) in
            
            guard let depart = departure else  {
                print("The departures are nil")
                return
            }
            
            guard let arrivalTime = depart.arrivalTime else {
                print("no arrival time detected")
                return
            }
            
            guard let platformName = depart.platformName else {
                print("no platform name detected")
                return
            }
            
            guard let lineName = depart.lineName else {
                print("no line name detected")
                return
            }
            
            guard let destination = depart.destinationName else {
                print("no destination detected")
                return
            }
            
            let trainTime = TrainTime()
            
            self.platformMessage = "The next train to arrive will be the \(lineName) service to \(destination). This train arrives in \(trainTime.formatArrivalTime(trainTime: arrivalTime))"

        }
        
        return self.platformMessage
        
        
    }
    
    @IBAction func IncreaseFontSize(_ sender: UIButton) {
        increaseFontSize()
    }
    
    @IBAction func DecreaseFontSize(_ sender: UIButton) {
        decreaseFontSize()
    }
    
    
    @IBAction func tapRepeatsSpeech(_ sender: UITapGestureRecognizer) {
        beepMessage.playSound()
        textToSpeech(string: self.distanceReading.text!)
    }
    
    
    
    }

