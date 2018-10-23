//
//  KeyEditViewController.swift
//  Kagi
//
//  Created by Luke Campbell on 10/17/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import UIKit

/**

 Provides the interface for delegates to implement. Delegates are primarily
 responsible for responding to the view's actions such as saving, or canceling.

 */
protocol KeyEditViewControllerDelegate: class {
    func keyEditViewControllerDidCancel(_ controller: KeyEditViewController)
    func keyEditViewControllerDidSave(_ controller: KeyEditViewController, kagi: Kagi)
    func keyEditViewControllerDidPressBack(_ controller: KeyEditViewController, kagi: Kagi)
}

class KeyEditViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dataField: UITextView!
    
    weak var delegate: KeyEditViewControllerDelegate?
    
    /** 
     The Managed Object that this view represents. It is assigned by the parent
     view during the segue
     */
    var kagi: Kagi?
    /**
     True if the view represents a newly created Kagi from the user hitting '+'
     */
    var newKagi: Bool?

    //----------------------------------------
    // MARK: View Overrides
    //----------------------------------------

    override func viewDidLoad() {
        // Create a border around the data field
        self.dataField.layer.borderWidth = 0.8
        self.dataField.layer.cornerRadius = 5
        self.dataField.layer.borderColor = UIColor.lightGray.cgColor

        // Assign this view controller as the delegate for the text field so
        // that we can dismiss the keyboard
        self.nameField.delegate = self
        
        // Add a 'Done' toolbar when the user edits the data field which allows
        // the user to dismiss the keyboard
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let generateBtn = UIBarButtonItem(title: "Generate", style: .plain, target: self, action: #selector(KeyEditViewController.generateButtonAction))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(KeyEditViewController.doneButtonAction))
        toolbar.setItems([flexSpace, generateBtn, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.dataField.inputAccessoryView = toolbar
        
        // Capture gestures so the user can dimiss the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        render()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        // If parent is nil, then the user pressed the back button
        if parent == nil {
            // Assign the data from the text fields to the Kagi and pass that to the delegate
            if let kagi = self.kagi {
                kagi.name = nameField.text
                kagi.data = dataField.text
                delegate?.keyEditViewControllerDidPressBack(self, kagi: kagi)
            }
        }
    }

    //----------------------------------------
    // MARK: View Methods
    //----------------------------------------
    
    
    /**
     Assigns text from kagi to the view's text fields
     */
    func render() {
        nameField.text = kagi?.name ?? "Unknown"
        dataField.text = kagi?.data ?? ""
    }

    //----------------------------------------
    // MARK: Delegate Methods
    //----------------------------------------
    
    /**
     Delegate method as part of UITextFieldDelegate. This method causes the
     text field to resign as first responder which dismisses the keyboard, when
     the user presses enter on the keyboard.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //----------------------------------------
    // MARK: Actions
    //----------------------------------------
    
    /**
     Dismisses the keyboard. This method is called when the user clicks 'Done'
     on the input accessory toolbar.
     */
    @objc
    func doneButtonAction() {
        self.view.endEditing(true)
    }

    @objc
    func generateButtonAction() {
        dataField.text = "Generated passphrase goes here"
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "showGenKey", sender: self)
    }
    /**
     Assigns the data from the view fields to the Kagi and passes the object to
     the delegate
     */
    @IBAction func onClickSave(_ sender: Any) {
        if let kagi = self.kagi {
            kagi.name = nameField.text
            kagi.data = dataField.text
            delegate?.keyEditViewControllerDidSave(self, kagi: kagi)
        }
    }
    /**
     Informs the delegate that cancel was clicked.
     */
    @IBAction func onClickCancel(_ sender: Any) {
        
        delegate?.keyEditViewControllerDidCancel(self)
    }
}
