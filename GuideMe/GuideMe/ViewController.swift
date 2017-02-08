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
    var message: String = ""

    var lastMessage = ""
    var apiService = APIService()
    var speech = TextToSpeech()
    var vibrate = Vibrate()
    var receivedDestination: String = ""
    var textToSpeechOn: Bool = true
    
    @IBOutlet weak var distanceReading: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.black
        self.lastMessage = "Welcome to Guide Me. You are being guided to: " + receivedDestination
        self.distanceReading.text = lastMessage
        self.textToSpeech(string: lastMessage)
        
        print(self.textToSpeechOn)
        
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

        1: "Stairs ahead, follow the handrail on the left, go down 13 steps",
        41693: "Follow the handrail left, 180 degrees, go down 13 steps",
        49281: "You are at the bottom of the stairs, keep right against the wall, walk straight ahead",
        50300: "Turn left to approach the ticket barriers",
        50500: "Ticket machines are on your left, keep left for the wide gate",
        50800: "Turn right for Westbound platform",
        65159: "You are now on the Westbound platform",
        66666: "The next train to arrive will be the District service to Wimbledon. This train arrives in 2 minutes"
    ]

    var fromPlatform: [Int: String] = [
        
        65159: "You are now on the Aldgate platform",
        60000: "Turn left for WhiteChapel Road",
        50800: "Turn right for Commercial Street",
        50500: "You are approaching the ticket barriers, keep right for the wide gate",
        50300: "Keep right, follow the wall and turn right",
        49281: "Stairs ahead, go up 13 steps, handrail on your left",
        41693: "Follow the handrail left, 180 degrees, go up 13 steps",
        1: "You are now exiting Algate station"
    ]

    
    func enterFromRoad(beaconNumber: Int) {

        guard let unwrappedMessage = fromRoad[beaconNumber] else {
            print ("I don't recognise this beacon")
            return
        }
        
        if beaconNumber == 65159 {
            setTextLabelAndSpeak(text: (getPlatformMessage()))
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
        guard let unwrappedMessage = fromPlatform[beaconNumber] else {
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
    
    var lastBeacon : Int = 0
    
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
            enterFromRoad(beaconNumber: beaconNumber)
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
            speech.playSound()
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
            
            self.message = "The next train to arrive will be the \(lineName) service to \(destination). This train arrives in \(trainTime.formatArrivalTime(trainTime: arrivalTime))"

        }
        
        return self.message
        
        
    }
    
    @IBAction func IncreaseFontSize(_ sender: UIButton) {
        increaseFontSize()
    }
    
    @IBAction func DecreaseFontSize(_ sender: UIButton) {
        decreaseFontSize()
    }
    
    
    @IBAction func tapRepeatsSpeech(_ sender: UITapGestureRecognizer) {
        print("TAPBEINGCALLED")
        speech.playSound()
        textToSpeech(string: self.distanceReading.text!)
    }
    
    
    
    }

