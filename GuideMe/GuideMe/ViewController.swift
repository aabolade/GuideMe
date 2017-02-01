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

    @IBOutlet weak var distanceReading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    textToSpeech()
                    startScanning()
                }
            }
           
        }
    }
    
    func startScanning() {
        guard let uuid = UUID(uuidString: "25556b57fe6d") else {
            print("UUID is nil")
            return
            
        }
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 8981, minor:  49281, identifier: "Beacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self ] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "Near"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    
    @IBOutlet weak var textView: UILabel!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "Guide me has begun scanning")

    func textToSpeech() {
        myUtterance = AVSpeechUtterance(string: "Guide me has begun scanning")
        myUtterance.rate = 0.3
        myUtterance.volume = 1.0
        synth.speak(myUtterance)
    }
}

