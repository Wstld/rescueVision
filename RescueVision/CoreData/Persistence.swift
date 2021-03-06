//
//  Persistence.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-19.
//

import CoreData
//prep for coredata usages.

struct PresistenceController{
    static let shared = PresistenceController()
    
    let container:NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "")
        
        container.loadPersistentStores { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error:\(error)")
            }
        }
    }
}
