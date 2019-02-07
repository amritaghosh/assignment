//
//  DataImporter.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit

class DataImporter: NSObject {
    
    var count: Int32 = 0
    
    static let sharedManager = DataImporter()
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
    
    //Extract Login Details
    func extractLoginData(parameters : Dictionary <String, Any>)  {
         if let response = parameters["data"] as? Dictionary<String, Any> {
            SystemManager.sharedManager.setToken(response["token"] as! String)
        }
    }
    
    func extractPlayerListData(parameters : Dictionary <String, Any>) throws {
        if let data = parameters["data"] as? Dictionary<String, Any> {
            if let playersArray = data["players"] as? [Dictionary<String, Any>] {
                for playerDictionary:Dictionary<String,Any> in playersArray {
                    
                    var player: PlayerList?
                
                    // Note
                    guard let newPlayerId = playerDictionary["player_id"] as? Int64  else {
                        
                        let localizedDescription = NSLocalizedString(Server.error, comment: "")
                        throw NSError(domain: NetworkManager.ErrorDomain, code: 999, userInfo: [
                            NSLocalizedDescriptionKey: localizedDescription])
                    }
                    player = PlayerList.findPlayerList(newPlayerId)
                    if (player == nil) {
                        player = PlayerList.newObject()
                    }
                    do {
                        try player?.updateFromDictionary(playerDictionary)
                    }
                    catch {
                        //error fetch author Data
                    }
                }
                
                //Save context
                
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
            }
            
        }
    }
    
    
    func extractFilterData(parameters : Dictionary <String, Any>) throws {
        var filterList: Filter?
        
        if let response = parameters["data"] as? Dictionary<String, Any> {
            if let categoryArray = response["categories"] as? [Dictionary<String, Any>] {
                for categoryDictionary:Dictionary<String,Any> in categoryArray {
                 
                    guard let newFilterId = categoryDictionary["id"] as? Int64  else {
                        
                        let localizedDescription = NSLocalizedString(Server.error, comment: "")
                        throw NSError(domain: NetworkManager.ErrorDomain, code: 999, userInfo: [
                            NSLocalizedDescriptionKey: localizedDescription])
                    }
                    filterList = Filter.findFilterList(newFilterId)
                    if (filterList == nil) {
                        filterList = Filter.newObject()
                    }
                    do {
                        try filterList?.updateFromDictionary(categoryDictionary, section: 1, sectionTitle: "Categories")
                    }
                    catch {
                        //error fetch author Data
                    }
                }
                //Save context
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
            }
            if let buildingArray = response["buildings"] as? [Dictionary<String, Any>] {
                for buildingDictionary:Dictionary<String,Any> in buildingArray {
                    
                    guard let newFilterId = buildingDictionary["id"] as? Int64  else {
                        
                        let localizedDescription = NSLocalizedString(Server.error, comment: "")
                        throw NSError(domain: NetworkManager.ErrorDomain, code: 999, userInfo: [
                            NSLocalizedDescriptionKey: localizedDescription])
                    }
                    filterList = Filter.findFilterList(newFilterId)
                    if (filterList == nil) {
                        filterList = Filter.newObject()
                    }
                    do {
                        try filterList?.updateFromDictionary(buildingDictionary, section: 2, sectionTitle: "Buildings")
                    }
                    catch {
                        //error fetch author Data
                    }
                }
                //Save context
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
            }
            if let skillsArray = response["skills"] as? [Dictionary<String, Any>] {
                for skillsDictionary:Dictionary<String,Any> in skillsArray {
                    
                    guard let newFilterId = skillsDictionary["id"] as? Int64  else {
                        
                        let localizedDescription = NSLocalizedString(Server.error, comment: "")
                        throw NSError(domain: NetworkManager.ErrorDomain, code: 999, userInfo: [
                            NSLocalizedDescriptionKey: localizedDescription])
                    }
                    filterList = Filter.findFilterList(newFilterId)
                    if (filterList == nil) {
                        filterList = Filter.newObject()
                    }
                    do {
                        try filterList?.updateFromDictionary(skillsDictionary, section: 3, sectionTitle: "Skills")
                    }
                    catch {
                        //error fetch author Data
                    }
                }
                //Save context
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                
            }
            if let statusArray = response["team_status"] as? [Dictionary<String, Any>] {
                for statusDictionary:Dictionary<String,Any> in statusArray {
                    
                    guard let newFilterId = statusDictionary["id"] as? Int64  else {
                        
                        let localizedDescription = NSLocalizedString(Server.error, comment: "")
                        throw NSError(domain: NetworkManager.ErrorDomain, code: 999, userInfo: [
                            NSLocalizedDescriptionKey: localizedDescription])
                    }
                    filterList = Filter.findFilterList(newFilterId)
                    if (filterList == nil) {
                        filterList = Filter.newObject()
                    }
                    do {
                        try filterList?.updateFromDictionary(statusDictionary, section: 4, sectionTitle: "Team_status")
                    }
                    catch {
                        //error fetch author Data
                    }
                }
                //Save context
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)

            }
        }
        
    }

    
    //Extract Error
    func extractError(error : NSError) throws {
        throw NSError(domain: NetworkManager.ErrorDomain, code: 401, userInfo: ["message" : "Error!!!"])
    }
   
}

