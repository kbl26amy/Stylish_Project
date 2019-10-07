//
//  singleton manager.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/25.
//  Copyright © 2019 AmyYang. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    static let storagsharedmanager = StorageManager()
    private var buyItem: [CartProduct] = []
    init() {
    }

    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "STYLISH")
        container.loadPersistentStores(completionHandler: { (cartBuyItem, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func removeBuyItem (position: Int) {
        self.buyItem.remove(at: position)
    }
    
    func getBuyItem() -> [CartProduct] {
        return self.buyItem
    }
    
    func fetchBuyItem () {
        let managedContext =
                    StorageManager.storagsharedmanager.viewContext
        
                let fetchRequest =
                    NSFetchRequest<CartProduct>(entityName: "CartProduct")
                do {
                    buyItem = try managedContext.fetch(fetchRequest)
                    print("fetch拿到\(StorageManager.storagsharedmanager.getBuyItem().count)")
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
    }
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
