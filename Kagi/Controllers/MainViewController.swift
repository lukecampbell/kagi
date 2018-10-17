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

class MainViewController: UITableViewController, KeyEditViewControllerDelegate {
    enum tags: Int {
        case cellLabel = 1000
    }
    @IBOutlet weak var theButton: UIButton!
    
    var moc: NSManagedObjectContext?
    
    static let cellReuseId = "KeychainItem"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let context = moc {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kagi")
            do {
                let count = try context.count(for: fetchRequest)
                return count
            } catch {
                print("Error: \(error)")
                return 0
            }
        } else {
            return 0
        }
    }
    
    func readKagi() -> [Kagi] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kagi")
        if let context = moc {
            do {
                let results = try context.fetch(fetchRequest)
                for data in results as! [Kagi] {
                    print(data.name)
                }
                return results as! [Kagi]
            } catch {
                print("Failed to read data: \(error)")
                return []
            }
        }
        return []
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeychainItem", for: indexPath) as! KeychainItemView
        
        let items = readKagi()
        cell.cellLabel.text = items[indexPath.row].name ?? "Unknown"
        cell.kagi = items[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        moc = appDelegate.persistentContainer.viewContext
        let context = moc!
        let entity = NSEntityDescription.entity(forEntityName: "Kagi", in: context)
        let newKey = Kagi(entity: entity!, insertInto: context)
        newKey.setValue("example", forKey: "name")
        newKey.setValue("abc123", forKey: "data")
    }
    
    func createKagi() -> Kagi? {
        if let context = moc {
            let entity = NSEntityDescription.entity(forEntityName: "Kagi", in: context)
            let newKey = Kagi(entity: entity!, insertInto: context)
            return newKey
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showKeyEditView" {
            let controller = segue.destination as! KeyEditViewController
            prepareEditSegue(for: controller, sender: sender as? KeychainItemView)
        } else if segue.identifier == "newKey" {
            let controller = segue.destination as! KeyEditViewController
            prepareNewSegue(for: controller)
        }
    }
    
    func prepareEditSegue(for controller: KeyEditViewController, sender: KeychainItemView?) {
        if let kagi = sender?.kagi {
            controller.kagi = kagi
        }
        controller.delegate = self
    }
    
    func prepareNewSegue(for controller: KeyEditViewController) {
        if let kagi = createKagi() {
            controller.kagi = kagi
        }
        controller.delegate = self
    }
    
    func keyEditViewControllerDidCancel(_ controller: KeyEditViewController) {
        controller.navigationController?.popViewController(animated: true)
        controller.dismiss(animated: true)
        print("Dimissed")
    }
    
    func keyEditViewControllerDidSave(_ controller: KeyEditViewController, kagi: Kagi) {
        controller.navigationController?.popViewController(animated: true)
        controller.dismiss(animated: true)
        let items = readKagi()
        if let index = items.index(of: kagi) {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? KeychainItemView
            cell?.cellLabel.text = kagi.name ?? "Unknown"
        }
    }
    
}
