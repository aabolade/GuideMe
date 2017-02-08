//
//  BeaconNaming.swift
//  GuideMe
//
//  Created by Courtney Osborn on 08/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation

class BeaconResponse {

    var viewController = ViewController()
    var lastBeacon : Int = 0
    
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
        41693: "Stairs ahead, go up 13 steps",
        1: "You are exiting Algate station"
    ]
    
    
    func enterFromRoad(beaconNumber: Int) {
        
        guard let unwrappedMessage = fromRoad[beaconNumber] else {
            print ("I don't recognise this beacon")
            return
        }
        
        if beaconNumber == 65159 {
            viewController.setTextLabelAndSpeak(text: viewController.getPlatformMessage())
        } else {
            viewController.setTextLabelAndSpeak(text: unwrappedMessage)
        }
    }
    
    func enterFromTrain(beaconNumber: Int) {
        guard let unwrappedMessage = fromPlatform[beaconNumber] else {
            print ("I don't recognise this beacon")
            return
        }
        viewController.setTextLabelAndSpeak(text: unwrappedMessage)
    }

    func giveDirections(beaconNumber: Int) {
        if beaconNumber < lastBeacon || beaconNumber == 65159 {
            enterFromTrain(beaconNumber: beaconNumber)
            lastBeacon = beaconNumber
        } else if beaconNumber > lastBeacon {
            enterFromRoad(beaconNumber: beaconNumber)
            lastBeacon = beaconNumber
        } else if beaconNumber == lastBeacon {
            viewController.setTextLabelAndSpeak(text: viewController.lastMessage)
        } else {
            viewController.setTextLabelAndSpeak(text: "I'm a bit confused.")
        }
    }


}
