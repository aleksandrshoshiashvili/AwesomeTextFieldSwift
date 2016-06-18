//
//  ViewController.swift
//  AwesomeTextField
//
//  Created by MacBookPro on 22.07.15.
//  Copyright (c) 2015 MacBookPro. All rights reserved.
//

import UIKit
import AwesomeTextField

class ViewController: UIViewController {

    @IBOutlet weak var awesomeTextField: AwesomeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.awesomeTextField .resignFirstResponder()
        
    }

}

