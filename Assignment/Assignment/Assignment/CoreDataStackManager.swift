//
//  CoreDataStackManager.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStackManager : NSObject {
    
    static private (set) var sharedManagerInstance: CoreDataStackManager? = CoreDataStackManager()
    
    static var sharedManager: CoreDataStackManager {
        return CoreDataStackManager.sharedManagerInstance!
    }
    
    private override init() {
        super.init()
        
    } //This prevents others from using the default '()' initializer for this class.
    
    func disposeOf()
    {
        CoreDataStackManager.sharedManagerInstance = nil
        CoreDataStackManager.sharedManagerInstance = CoreDataStackManager()
    }

    // MARK: - Core Data stack
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            let context = self.persistentContainer.newBackgroundContext()
            return context
        } else {
            let context = self.newPrivateQueueContext
            return context
        }
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            let context = self.persistentContainer.viewContext
            return context
        } else {
            let context = self.mainQueueContext
            return context
        }
    }()

    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: CoreDataStackManager.assignmentModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                //fatalError("Unresolved error \(error), \(String(describing: error._userInfo))")
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // Need to check on iOS 10
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveViewContext () {
        let context = self.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               // AlertsManager.sharedManager.enqueueAlert(Alerts.genericError)
            }
        }
    }
    
    func save(context : NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
              //  context.reset()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")

               // AlertsManager.sharedManager.enqueueAlert(Alerts.genericError)
            }
        }
        
    }
    

    static let applicationDocumentsDirectoryName =  Bundle.main.bundleIdentifier ?? "com.ness-ses.Assignment"
    static let mainStoreFileName = "CoreDataModel.storedata"
    static let errorDomain = "CoreDataStackManager"
    static let assignmentModel = "CoreDataModel"

    
    // The managed object model for the application.
    //
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        // This property is not optional. It is a fatal error for the application
        // not to be able to find and load its model.
        //
       let modelURL = Bundle.main.url(forResource: CoreDataStackManager.assignmentModel, withExtension: "mom")

        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    // Primary persistent store coordinator for the application.
    //
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // This implementation creates and return a coordinator, having added the
        // store for the application to it. (The directory for the store is created, if necessary.)
        //
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: options)
        }
        catch {
//            fatalError("Could not add the persistent store: \(error).")
        }
        
        return persistentStoreCoordinator
    }()
    
    
    lazy var mainQueueContext: NSManagedObjectContext = {
        
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // Avoid using default merge policy in multi-threading environment:
        // when we delete (and save) a record in one context,
        // and try to save edits on the same record in the other context before merging the changes,
        // an exception will be thrown because Core Data by default uses NSErrorMergePolicy.
        // Setting a reasonable mergePolicy is a good practice to avoid that kind of exception.
        
        moc.mergePolicy = NSOverwriteMergePolicy
        
        // In macOS, a context provides an undo manager by default
        // Disable it for performance benefit
        //
        moc.undoManager = nil
        
        return moc
    }()
    
    
    
    /// The directory the application uses to store the Core Data store file.
    //
    lazy var applicationSupportDirectory: URL = {
        
        let fileManager = FileManager.default
        
        // Use the app support directory directly if URLByAppendingPathComponent failed.
        //
        var supportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
        
        let applicationSupportDirectory = supportDirectory.appendingPathComponent(CoreDataStackManager.applicationDocumentsDirectoryName)
        
        do {
            let properties = try applicationSupportDirectory.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
            if let isDirectory = properties.allValues[URLResourceKey.isDirectoryKey] as? Bool, isDirectory == false {
                
                let description = NSLocalizedString("Could not access the application data folder.", comment: "Failed to initialize applicationSupportDirectory.")
                
                let reason = NSLocalizedString("Found a file in its place.", comment: "Failed to initialize applicationSupportDirectory.")
                
                throw NSError(domain: CoreDataStackManager.errorDomain, code: 201, userInfo: [
                    NSLocalizedDescriptionKey: description,
                    NSLocalizedFailureReasonErrorKey: reason
                    ])
            }
        }
        catch let error as NSError where error.code != NSFileReadNoSuchFileError {
            //fatalError("Error occured: \(error).")
        }
        catch {
            let path = applicationSupportDirectory.path
            
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories:true, attributes:nil)
            }
            catch {
                //fatalError("Could not create application documents directory at \(path).")
            }
        }
        
        return applicationSupportDirectory
    }()
    
    // URL for the main Core Data store file.
    //
    lazy var storeURL: URL = {
        return self.applicationSupportDirectory.appendingPathComponent(CoreDataStackManager.mainStoreFileName)
        }()
    
    
    // Creates a new Core Data stack and returns a managed object context associated with a private queue.
    //
    func newPrivateQueueContextWithNewPSC() throws -> NSManagedObjectContext {
        
        // Stack uses the same store and model, but a new persistent store coordinator and context.
        //
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: CoreDataStackManager.sharedManager.managedObjectModel)
        
        // Attempting to add a persistent store may yield an error--pass it out of
        // the function for the caller to deal with.
        //
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: CoreDataStackManager.sharedManager.storeURL, options: nil)
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.performAndWait() {
            
            context.persistentStoreCoordinator = coordinator
            
            // Avoid using default merge policy in multi-threading environment:
            // when we delete (and save) a record in one context,
            // and try to save edits on the same record in the other context before merging the changes,
            // an exception will be thrown because Core Data by default uses NSErrorMergePolicy.
            // Setting a reasonable mergePolicy is a good practice to avoid that kind of exception.
            //
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            // In macOS, a context provides an undo manager by default
            // Disable it for performance benefit
            //
            context.undoManager = nil
        }
        
        return context
    }

    lazy var newPrivateQueueContext: NSManagedObjectContext = {
        do {
            let context = try self.newPrivateQueueContextWithNewPSC()
            NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveNotificationHandler(notification:)),
                                                             name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)

            return context
        }
        catch {
            fatalError("Could not create a new Private Queue Context: \(error).")
            //AlertsManager.sharedManager.enqueueAlert(Alerts.genericError)
        }
    }()

    // Handler for NSManagedObjectContextDidSaveNotification.
    // Observe NSManagedObjectContextDidSaveNotification and merge the changes to the main context from other contexts.
    // We rely on this to sync between contexts, thus avoid most of merge conflicts and keep UI refresh.
    // In the sample code, we don’t edit the main context so not syncing with the private queue context won’t trigger any issue.
    // However, a real app may not as simple as this. We normally need to handle this notificaiton.
    //
    @objc func contextDidSaveNotificationHandler(notification: Notification){
        
        let sender = notification.object as! NSManagedObjectContext
        if sender !== self.mainQueueContext {
            self.mainQueueContext.perform {
                self.mainQueueContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }

    
    func deleteCoreDataDbFiles() {
        let fileManager = FileManager.default
        let supportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last!
        
        do {
            let filesURLs = try fileManager.contentsOfDirectory(atPath: supportDirectory.path)
            
            for filePathComponent in filesURLs {
                if filePathComponent.contains(CoreDataStackManager.assignmentModel) || filePathComponent.contains(CoreDataStackManager.applicationDocumentsDirectoryName) {
                    let fileURL = supportDirectory.appendingPathComponent(filePathComponent)
                    do {
                        try fileManager.removeItem(at: fileURL)
                    } catch let error as NSError  {
                        print(error) // TODO:
                    }
                }
            }
        } catch let error as NSError  {
            print(error) // TODO:
        }
    }

    func reinitialize() {
        CoreDataStackManager.sharedManager.deleteCoreDataDbFiles()
        CoreDataStackManager.sharedManager.disposeOf()
    }
}
