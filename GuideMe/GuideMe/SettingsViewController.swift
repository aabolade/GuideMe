//
//  SettingsViewController.swift
//  GuideMe
//
//  Created by Courtney Osborn on 02/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func makeChangesToFont(size: Int)
}

class SettingsViewController: UIViewController {
    
    var delegate: SettingsViewControllerDelegate?
    
//    @IBOutlet weak var fontSize: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func sendDataToMainView(fontSize : Int) {
//        let mainView = parent as! ViewController
//        mainView.updateFontSize(fontSize :fontSize)
//    }
    
//    func increaseFontSize() {
//        let mainView = parent as! ViewController
//        let text = mainView.distanceReading
//        let fontSize = (text?.font.pointSize)! + 10
////        sendDataToMainView(fontSize: Int(fontSize))
//        mainView.updateFontSize(fontSize: Int(fontSize))
//    }
//    

    @IBAction func IncreaseSize(_ sender: UIButton) {
        print("something")
        increaseFontSize()
    }
    
    func increaseFontSize() {
        let mainView = parent as! ViewController
        let text = mainView.distanceReading
        let fontSize = (text?.font.pointSize)! + 10
        print(fontSize)
        
        if let delegate = self.delegate {
            delegate.makeChangesToFont(size: Int(fontSize))
        }
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
    
    


}
