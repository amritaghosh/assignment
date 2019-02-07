//
//  PlayerList+Functionality.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//
import Foundation
import CoreData

extension PlayerList {
    
    func updateFromDictionary(_ playerListDictionary: Dictionary<String, Any>) throws {
        
        if let ageValue    =  (playerListDictionary["age"] as? Int64) {
            age = ageValue
        }
        
        if let playerIdValue    =  (playerListDictionary["player_id"] as? Int64) {
            playerId = playerIdValue
        }
        
        if let pointsValue    =  (playerListDictionary["points"] as? Int64) {
            points = pointsValue
        }
        
        if let teamStatusValue    =  (playerListDictionary["team_status"] as? Int64) {
            team_status = teamStatusValue
        }
        
        base_price = playerListDictionary["base_price"] as? String
        batsman = playerListDictionary["batsman"] as? String
        bowler = playerListDictionary["bowler"] as? String
        building = playerListDictionary["building"] as? String
        category_name = playerListDictionary["category_name"] as? String
        name = playerListDictionary["name"] as? String
        picture = playerListDictionary["picture"] as? String
        points_type = playerListDictionary["points_type"] as? String
        team = playerListDictionary["team"] as? String
        
        isFetching = true

    }
    
    
    class func findPlayerList(_ id : Int64) -> PlayerList? {
        let request: NSFetchRequest<PlayerList> = PlayerList.fetchRequest()
        request.predicate = NSPredicate.init(format: "playerId = %i", id as CVarArg)
        do {
            let fetchResults = try CoreDataStackManager.sharedManager.managedObjectContext.fetch(request)
            return fetchResults.count > 0 ? fetchResults.first! : nil
        } catch {
           // print("Error with request: \(error)")
        }
        return nil
    }

    
    class func newObject() -> PlayerList {
        var playerList: PlayerList
        if #available(iOS 10.0, *) {
            playerList = PlayerList(context: CoreDataStackManager.sharedManager.managedObjectContext)
        } else {
            // Fallback on earlier versions
            playerList =  NSEntityDescription.insertNewObject(forEntityName: "PlayerList", into: CoreDataStackManager.sharedManager.managedObjectContext) as! PlayerList
        }
        return playerList
    }
    
}
