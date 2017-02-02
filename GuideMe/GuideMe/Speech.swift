//
//  Speech.swift
//  GuideMe
//
//  Created by Courtney Osborn on 02/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation
import AVFoundation

class Speech {
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "Guide me has begun scanning")
    
    func textToSpeechSettings(string: String) {
        myUtterance = AVSpeechUtterance(string: string)
        myUtterance.rate = 0.3
        myUtterance.volume = 1.0
        synth.speak(myUtterance)
    }

}
