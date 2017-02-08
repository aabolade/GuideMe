//
//  BeaconResponse.swift
//  GuideMe
//
//  Created by Courtney Osborn on 08/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation

class BeaconResponse {

    

    var fromRoad: [Int: String] = [
        
        1: "Stairs ahead, follow the handrail on the left, go down 13 steps",
        41693: "Follow the handrail Left, 180 degrees, go down 13 steps",
        49281: "You are at the bottom of the stairs, Keep Right against the Wall, walk straight ahead",
        50300: "Turn Left in 5 steps",
        50500: "You are approaching the ticket barriers, ticket machines are on your left, Keep Left for the Wide Gate",
        50800: "Turn Right, for westbound platform",
        65159: "You are now on the Westbound Platform"
    ]
    
    var fromPlatform: [Int: String] = [
        
        65159: "You are now on the Algate platform",
        60000: "Turn Left for WhiteChapel Road",
        50800: "Turn Right for Commercial Street",
        50500: "You are approaching the ticket barriers, Keep Right for the Wide Gate",
        50300: "Keep Right, follow the wall and turn right",
        49281: "Stairs Ahead, go up 13 steps, handrail on your left",
        41693: "Follow the handrail Left, 180 degrees, go up 13 steps",
        1: "You are now exiting Algate station"
    ]
    

    
}
