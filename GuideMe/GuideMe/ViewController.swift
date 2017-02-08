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
        41693: "Follow the handrail Left, 180 degrees, go down 13 steps",
        49281: "You are at the bottom of the stairs, Cross to Left Wall, walk straight ahead",
        50300: "Turn Left at the next corner",
        50500: "You are approaching the ticket barriers, Keep Left for the Wide Gate",
        50800: "Turn Right, for westbound platform",
        65159: "You are now on the Westbound Platform"
    ]

    var fromPlatform: [Int: String] = [
        
        65159:  "You are now on the Algate platform",
        49281:  "Turn Right",
        41693: "Stairs ahead, go up 56 steps",
        1: "You are exiting Algate station"
    ]

    
    func enterFromRoad(beaconNumber: Int) {

        guard let unwrappedMessage = fromRoad[beaconNumber] else {
            print ("I don't recognise this beacon")
            return
        }
        
        if beaconNumber == 65159 {
            setTextLabelAndSpeak(text: getPlatformMessage())
        } else {
            setTextLabelAndSpeak(text: unwrappedMessage)
        }
    }
    
    func enterFromTrain(beaconNumber: Int) {
        guard let unwrappedMessage = fromPlatform[beaconNumber] else {
            print ("I don't recognise this beacon")
            return
        }
        setTextLabelAndSpeak(text: unwrappedMessage)
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
        if beaconNumber < lastBeacon || beaconNumber == 65159 {
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
                print("")
                return
            }
            
            guard let platformName = depart.platformName else {
                print("")
                return
            }
            
            guard let lineName = depart.lineName else {
                print("")
                return
            }
            
            guard let destination = depart.destinationName else {
                print("")
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

