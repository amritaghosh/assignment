//
//  DownSyncManager.swift
//  Assignment
//
//  Created by Amrita Ghosh on 05/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit
import Foundation


class DownSyncManager : NSObject {
    
    static let sharedManager = DownSyncManager()
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
    
    //MARK: Authentication
    
    func authenticateLogin(_ emailId: String, withPassword password: String, completion: @escaping NetworkRetrieverDataTaskDidReceiveData){
        //Call NetworkManager counter method
        NetworkManager.sharedManager.authenticateLogin(emailId, withPassword: password, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            let loginResponseDictionary = responseObject as! Dictionary<String, Any>
            do {
                try DataImporter.sharedManager.extractLoginData(parameters: loginResponseDictionary)
                completion(responseObject, nil)
            } catch {
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }
    
    
    func fetchPlayerList(_ category: String, skill: String, building: String, team_status: String, isRefresh: Bool, completion: @escaping NetworkRetrieverDataTaskDidReceiveData) {
        
        var payload: [String : Any] = [:]
        if category != "" {
            payload["category"] = category
        }
        else if skill != "" {
            payload["skill"] = skill
        }
        else if building != "" {
            payload["building"] = building
        }
        else if team_status != "" {
            payload["team_status"] = team_status
        }
        
        
        NetworkManager.sharedManager.fetchPlayerList(payload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
                do {
                    if(isRefresh) {
                        SystemManager.sharedManager.deletePlayerList()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    try DataImporter.sharedManager.extractPlayerListData(parameters: responseObject as! Dictionary<String, Any>)
                    completion(responseObject, nil)
                } catch {
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
        })
            
    }
    
    
    
    func fetchFilterList(completion: @escaping NetworkRetrieverDataTaskDidReceiveData) {
       
        NetworkManager.sharedManager.fetchFilterData(completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            let filterResponseDictionary = responseObject as! Dictionary<String, Any>
            do {
                try DataImporter.sharedManager.extractFilterData(parameters: filterResponseDictionary)
                completion(responseObject, nil)
            } catch {
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }
   
}


