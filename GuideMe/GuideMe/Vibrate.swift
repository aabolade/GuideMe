//
//  Vibrate.swift
//  GuideMe
//
//  Created by Louisa Spicer on 05/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation
import AudioToolbox

class Vibrate {
    
    var counter = 0
    var timer : Timer?
    
    @objc func threeVibrationsForLeft() {
        counter += 1
        switch counter {
        case 1, 2, 3:
            AudioServicesPlaySystemSound(1352)
        default:
            timer?.invalidate()
        }
    }
    
    @objc func twoVibrationsForRight() {
        counter += 1
        switch counter {
        case 1, 2:
            AudioServicesPlaySystemSound(1352)
        default:
            timer?.invalidate()
        }
    }
    
    func vibrateForLeft() {
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(Vibrate.threeVibrationsForLeft), userInfo: nil, repeats: true)
    }
    
    func vibrateForRight() {
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(Vibrate.twoVibrationsForRight), userInfo: nil, repeats: true)
    }
    
    
}
