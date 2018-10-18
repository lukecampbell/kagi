//
//  KagiStore.swift
//  Kagi
//
//  Created by Luke Campbell on 10/17/18.
//  Copyright © 2018 Lucas Campbell.
//  See LICENSE for details
//

import CoreData

fileprivate let ENTITY = "Kagi"

class KagiStore {
    let moc: NSManagedObjectContext
    var items: [Kagi]

    init(context: NSManagedObjectContext) throws {
        self.moc = context
        self.items = [Kagi]()
        try initializeStore()
    }

    private func initializeStore() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY)
        let results = try moc.fetch(fetchRequest)
        for data in results as! [Kagi] {
            items.append(data)
        }
    }

    func createKagi(name: String?, data: String?) -> Kagi {
        let entity = NSEntityDescription.entity(forEntityName: ENTITY, in: moc)
        let kagi = Kagi(entity: entity!, insertInto: moc)
        let uuid = UUID()
        kagi.name = name
        kagi.data = data
        kagi.id = uuid.uuidString
        items.append(kagi)
        return kagi
    }
    
    func deleteKagi(_ kagi: Kagi) {
        let index = items.index(of: kagi)!
        items.remove(at: index)
        moc.delete(kagi)
    }


}
