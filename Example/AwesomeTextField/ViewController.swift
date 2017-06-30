//
//  ViewController.swift
//  AwesomeTextField
//
//  Created by MacBookPro on 22.07.15.
//  Copyright (c) 2015 MacBookPro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var awesomeTextField: AwesomeTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.awesomeTextField.resignFirstResponder()
  }
  
}

