//
//  HomeViewController.swift
//  GuideMe
//
//  Created by Courtney Osborn on 02/02/2017.
//  Copyright © 2017 Leke Abolade. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ViewController
        viewController.receivedDestination = textField.text!
    }


}
