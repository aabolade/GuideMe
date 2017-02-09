//
//  MessageBeep.swift
//  GuideMe
//
//  Created by Leke Abolade on 09/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation
import AVFoundation

class MessageBeep {
    
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else {
            print("url is nil")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else {return}
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
