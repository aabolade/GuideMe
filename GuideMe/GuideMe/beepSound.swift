//
//  beepSound.swift
//  GuideMe
//
//  Created by Courtney Osborn on 06/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import Foundation
import AVFoundation

class BeepSound {
    
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
