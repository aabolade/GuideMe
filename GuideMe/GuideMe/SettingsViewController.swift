//
//  SettingsViewController.swift
//  GuideMe
//
//  Created by Courtney Osborn on 02/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import UIKit

protocol DataEnteredDelegate: class {
    func makeChangesToFontSize(size: Int)
}


class SettingsViewController: UIViewController {
    
    weak var delegate: DataEnteredDelegate? = nil
    
//    @IBOutlet weak var fontSize: UILabel!
    
    
    @IBAction func increaseFontSize(_ sender: UIButton) {
        
        delegate?.makeChangesToFontSize(size: <#T##Int#>)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func increaseFontSize () {
//        guard let unwrappedController = viewController else {
//            print("View Controller is nil!")
//            return
//        }
//        var text = unwrappedController.distanceReading.font
//        text = UIFont(name: "Courier Bold", size: (text?.pointSize)!+1)!
//    }
//    
//    func increaseFontSize () {
//        guard let unwrappedController = viewController else {
//            print("View Controller is nil!")
//            return
//        }
//        let text = unwrappedController.distanceReading
//        text?.font = UIFont(name: (text?.font.fontName)!, size: (text?.font.pointSize)! + 10)
//    }
//    
//    func updateFontSizeNumber() {
//        guard let unwrappedController = viewController else {
//            print("View Controller is nil!")
//            return
//        }
//        let text = unwrappedController.distanceReading
//        
//        self.fontSize.text = "\(text?.font.pointSize)!"
//    }
//    
//    @IBAction func FontButtonTapped(_ sender: UIButton) {
//        increaseFontSize()
//        updateFontSizeNumber()
//    }
//    
    


}
