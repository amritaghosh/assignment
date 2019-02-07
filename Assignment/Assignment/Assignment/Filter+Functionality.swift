//
//  Filter+Functionality.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//
import Foundation
import CoreData

extension Filter {
    
    func updateFromDictionary(_ filterDictionary: Dictionary<String, Any>, section: Int16, sectionTitle: String) throws {
        if let idValue    =  (filterDictionary["id"] as? Int64) {
            filterId = idValue
        }
        filterName = filterDictionary["name"] as? String
        sectionName = sectionTitle
        filterNo = section
        isFetching = true
    }
    
    
    class func findFilterList(_ id : Int64) -> Filter? {
        let request: NSFetchRequest<Filter> = Filter.fetchRequest()
        request.predicate = NSPredicate.init(format: "filterId = %i", id as CVarArg)
        do {
            let fetchResults = try CoreDataStackManager.sharedManager.managedObjectContext.fetch(request)
            return fetchResults.count > 0 ? fetchResults.first! : nil
        } catch {
           // print("Error with request: \(error)")
        }
        return nil
    }

    
    class func newObject() -> Filter {
        var filterList: Filter
        if #available(iOS 10.0, *) {
            filterList = Filter(context: CoreDataStackManager.sharedManager.managedObjectContext)
        } else {
            // Fallback on earlier versions
            filterList =  NSEntityDescription.insertNewObject(forEntityName: "Filter", into: CoreDataStackManager.sharedManager.managedObjectContext) as! Filter
        }
        return filterList
    }
    
}
