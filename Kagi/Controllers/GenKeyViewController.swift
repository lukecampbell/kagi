//
//  GenKeyViewController.swift
//  Kagi
//
//  Created by Lucas Campbell on 10/18/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import UIKit

protocol PassphraseGeneratedDelegate: class {
    func onPassphraseGenerated(passphrase: String) -> Void
}

class GenKeyViewController : UIViewController {
    weak var generateDelegate: PassphraseGeneratedDelegate?

}
