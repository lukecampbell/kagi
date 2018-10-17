//
//  MainViewController.swift
//  Kagi
//
//  Created by Luke Campbell on 7/20/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class MainViewController: UITableViewController {
    enum tags: Int {
        case cellLabel = 1000
    }
    @IBOutlet weak var theButton: UIButton!
    
    static let cellReuseId = "KeychainItem"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeychainItem", for: indexPath)
        let label = cell.viewWithTag(tags.cellLabel.rawValue) as! UILabel
        label.text = "Key " + String(indexPath.row)
        return cell
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DataStore", in: context)
        let newKey = NSManagedObject(entity: entity!, insertInto: context)
        newKey.setValue("example", forKey: "name")
        newKey.setValue("abc123", forKey: "data")
        
    }
    
}
