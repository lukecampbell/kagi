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
    
    var moc: NSManagedObjectContext?
    var kagiStore: KagiStore?
    
    static let cellReuseId = "KeychainItem"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kagiStore?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeychainItem", for: indexPath) as! KeychainItemView
        
        cell.cellLabel.text = kagiStore?.items[indexPath.row].name ?? "Unknown"
        cell.kagi = kagiStore?.items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            kagiStore!.deleteKagi(kagiStore!.items[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            kagiStore = try KagiStore(context: appDelegate.persistentContainer.viewContext)
            if let itemCount = kagiStore?.items.count, itemCount < 1 {
                _ = kagiStore?.createKagi(name: "First key", data: "Some example data")
            }
        } catch {
            fatalError("Failed to initialize kagi store: \(error)")
        }
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
        controller.newKagi = false
    }
    
    func prepareNewSegue(for controller: KeyEditViewController) {
        if let kagi = kagiStore?.createKagi(name: "New Key", data: "Data") {
            controller.kagi = kagi
        }
        controller.delegate = self
        controller.newKagi = true
    }
    
    func keyEditViewControllerDidCancel(_ controller: KeyEditViewController) {
        controller.navigationController?.popViewController(animated: true)
        controller.dismiss(animated: true)
    }
    
    func updateTableView(with kagi: Kagi) {
        if let index = kagiStore?.items.firstIndex(of: kagi) {
            if index >= tableView.numberOfRows(inSection: 0) {
                tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            } else {
                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? KeychainItemView
                cell?.cellLabel.text = kagi.name ?? "Unknown"
            }
        }
    }
    
    func keyEditViewControllerDidSave(_ controller: KeyEditViewController, kagi: Kagi) {
        controller.navigationController?.popViewController(animated: true)
        controller.dismiss(animated: true)
        updateTableView(with: kagi)
    }
    
    func keyEditViewControllerDidPressBack(_ controller: KeyEditViewController, kagi: Kagi) {
        updateTableView(with: kagi)
    }
    
}
