//
//  GenKeyViewController.swift
//  Kagi
//
//  Created by Lucas Campbell on 10/18/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import UIKit

class GenKeyViewController : UIViewController {
    override func viewDidLoad() {
        print("GenKeyViewController loaded")
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedGeneratorOptions" {
            print("Segue!")
        }
    }

}
