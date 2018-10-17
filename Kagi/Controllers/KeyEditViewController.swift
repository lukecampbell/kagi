//
//  KeyEditViewController.swift
//  Kagi
//
//  Created by Luke Campbell on 10/17/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import UIKit

protocol KeyEditViewControllerDelegate: class {
    func keyEditViewControllerDidCancel(_ controller: KeyEditViewController)
    func keyEditViewControllerDidSave(_ controller: KeyEditViewController, kagi: Kagi)
}

class KeyEditViewController : UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dataField: UITextView!
    
    weak var delegate: KeyEditViewControllerDelegate?
    
    var kagi: Kagi?
    
    override func viewDidLoad() {
        self.dataField.layer.borderWidth = 0.8
        self.dataField.layer.cornerRadius = 5
        self.dataField.layer.borderColor = UIColor.lightGray.cgColor
        render()
    }
    
    func render() {
        nameField.text = kagi?.name ?? "Unknown"
        dataField.text = kagi?.data ?? ""
    }

    @IBAction func onClickSave(_ sender: Any) {
        if let kagi = self.kagi {
            kagi.name = nameField.text
            kagi.data = dataField.text
            delegate?.keyEditViewControllerDidSave(self, kagi: kagi)
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        print("Clicked cancel")
        delegate?.keyEditViewControllerDidCancel(self)
    }
}
