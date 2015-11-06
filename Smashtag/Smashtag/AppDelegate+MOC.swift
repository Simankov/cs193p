//
//  AppDelegate+MOC.swift
//  Smashtag
//
//  Created by admin on 05/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//
import Foundation
import CoreData
extension AppDelegate {
    func createMainQueueManagedObjectContext() -> NSManagedObjectContext?{
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension:"momd")
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        let mom = NSManagedObjectModel(contentsOfURL: modelURL!)
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext?.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
            
            psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error : NSErrorPointer())
        }
        return managedObjectContext
    }
}