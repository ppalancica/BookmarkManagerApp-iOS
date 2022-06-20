//
//  CoreDataManager.swift
//  BookmarkManagerApp-iOS
//
//  Created by Pavel Palancica on 6/20/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var managedObjectContext: NSManagedObjectContext!
    
    func initalizeCoreDataStack() {
        guard let modelURL = Bundle.main.url(forResource: "BookmarksDataModel", withExtension: "momd") else {
            fatalError("BookmarksDataModel not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to initialize ManagedObjectModel")
        }
        
        let fileManager = FileManager()
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to get documents URL")
        }
        let storeURL = documentsURL.appendingPathComponent("BookmarksDataModel.sqlite")
        print(storeURL)
        
        let persistenceStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistenceStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        let concurrencyType = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = persistenceStoreCoordinator
    }
}
