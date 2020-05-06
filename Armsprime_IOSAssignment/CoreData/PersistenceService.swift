//
//  PersistenceService.swift
//  Armsprime_IOSAssignment
//
//  Created by Amsys on 02/02/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import Foundation
import CoreData
//this class is responsible for save,delete,fetch coredata
class PersistenceService {
    
    private init() {}
    static let shared = PersistenceService()
    
    var context:NSManagedObjectContext {return persistentContainer.viewContext}

    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "Armsprime_IOSAssignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func save(completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
               // print("saved successfully")
                completion()
               // NotificationCenter.default.post(name: NSNotification.Name("persistedDataUpdated"), object: nil)
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Delete Data Records

    func deleteRecords() -> Void {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")

         let result = try? context.fetch(fetchRequest)
            let resultData = result as! [News]

            for object in resultData {
                context.delete(object)
            }

            do {
                try context.save()
               // print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {

            }





    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
           let objects = try context.fetch(request)
            completion(objects)
        } catch {
            print(error)
            completion([])
        }
        
    }
    
}
