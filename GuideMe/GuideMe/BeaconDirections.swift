//
//  BeaconDirections.swift
//  GuideMe
//
//  Created by Leke Abolade on 09/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation

class BeaconDirections {
    
    
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

}
