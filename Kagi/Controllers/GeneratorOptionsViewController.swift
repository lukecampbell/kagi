//
//  GeneratorOptionsViewController.swift
//  Kagi
//
//  Created by Lucas Campbell on 10/18/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import UIKit

class GeneratorOptionsViewController : UITableViewController {
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var memorableSwitch: UISwitch!
    
    override func viewDidLoad() {
        print("GeneratorOptionsViewController loaded")
    }
}
