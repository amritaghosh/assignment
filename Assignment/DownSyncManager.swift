//
//  DownSyncManager.swift
//  ETW
//
//  Created by Afshan Momin on 20/01/17.
//  Copyright © 2017 Ness Digital Engineering. All rights reserved.
//

import UIKit
import Foundation


class DownSyncManager : NSObject {
    
    static let sharedManager = DownSyncManager()
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
    
    //MARK: Authentication
    
    //Authenticate Login with companyId, username, password
    func authenticateLogin(_ emailId: String, withPassword password: String, completion: @escaping NetworkRetrieverDataTaskDidReceiveData){
        //Call NetworkManager counter method
        NetworkManager.sharedManager.authenticateLogin(emailId, withPassword: password, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                return
            }
            let loginResponseDictionary = responseObject as! Dictionary<String, Any>
            do {
                try DataImporter.sharedManager.extractLoginData(parameters: loginResponseDictionary)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
                //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        })
    }
    
    //MARK: Forgot Password
    
    //Reset password using email ID
    func forgotPassword(resetEmail email:String, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's forgotPassword API and Handle Response
        NetworkManager.sharedManager.forgotPassword(resetEmail: email,completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let forgotPasswordResponseDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: forgotPasswordResponseDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
        
    }
    
    
    //MARK: Sign Out
    
    // Sign Out From User Account
    func signOut(completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's forgotPassword API and Handle Response
        NetworkManager.sharedManager.signOut(completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                return
            }
            if let logoutResponseDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractLogoutData(parameters: logoutResponseDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            completion(responseObject, nil)
        })
        
    }
    
    
    //MARK: UserAccount Information
    
    // User Account Info
    func userAccountInfo(_ userId:Int, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's forgotPassword API and Handle Response
        NetworkManager.sharedManager.userAccountInfo(userId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                DataImporter.sharedManager.setDefaultUserAccountInfo()
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            let userAccountInfoResponseDictionary = responseObject as! Dictionary<String, Any>
            do {
                try DataImporter.sharedManager.extractUserAccountInfo(parameters: userAccountInfoResponseDictionary)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
        
    }
    
    
    //MARK: Refresh
    
    // Refresh JWT tokens
    func refreshToken(completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's refresh Token API and Handle Response
        NetworkManager.sharedManager.refreshToken(completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                completion(responseObject, fetchError)
                return
            }
            let loginResponseDictionary = responseObject as! Dictionary<String, Any>
            do {
                try DataImporter.sharedManager.extractLoginData(parameters: loginResponseDictionary)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
        
    }
    
    
    //MARK: Notes
    
    // Notes unread messages
    func fetchUnreadMessageNotes(_ isPulltoRefresh: Bool, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        
        //Call NetworkManager's Notes unread messages API and Handle Response
        let lastEvalKey = isPulltoRefresh == true ? "" : DataUtilities.sharedManager.findUnreadNoteLastEvalKey(false)
        // CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
        
        NetworkManager.sharedManager.fetchUnreadMessageNotes(for: lastEvalKey, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        //try to cancel queue for avatarImage if exist
                        //  SystemManager.avatarOperationQueue.cancelAllOperations()
                        
                        DataUtilities.sharedManager.deleteNotes(archived: false)
                        // DataUtilities.sharedManager.deleteNotes(archived: false)
                        // TODO Delete Author and NoteGoals with notes count = 0
                        //CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    try NotesDataImpoter.sharedManager.extractUserNotes(response: responseObject!, archived: false)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
            
        })
        //}
        
    }
    
    
    // Archive A Note
    func archiveNote(_ messageId: String, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's Archive A Note API and Handle Response
        NetworkManager.sharedManager.archiveNote(messageId, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                if let archiveNoteResponseDictionary = responseObject as? Dictionary<String, Any> {
                    do {
                        try DataImporter.sharedManager.extractArchiveNoteData(parameters: archiveNoteResponseDictionary)
                        completion(responseObject, nil)
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        completion(responseObject, nserror)
                    }
                    return
                }
            }
            completion(responseObject, nil)
        })
        
    }
    
    // Archive All Note
    func archiveAllNotes(_ messageId: [String], completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        let messageIDsString = messageId.joined(separator: ",")
        
        //  CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
        
        //Call NetworkManager's Archive All Note API and Handle Response
        NetworkManager.sharedManager.archiveAllNotes(messageIDsString, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                if let archiveAllNoteResponseDictionary = responseObject as? Dictionary<String, Any> {
                    do {
                        try DataImporter.sharedManager.extractArchiveAllNotesData(parameters: archiveAllNoteResponseDictionary)
                        completion(responseObject, nil)
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        completion(responseObject, nserror)
                    }
                    return
                }
            }
            completion(responseObject, nil)
        })
        // }
    }
    
    
    //MARK: Notes Archive
    
    // Notes Archive messages
    func fetchArchiveNotes(_ isPulltoRefresh: Bool, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's Notes unread messages API and Handle Response
        let lastEvalKey = isPulltoRefresh == true ? "" : DataUtilities.sharedManager.findUnreadNoteLastEvalKey(true)
        
        NetworkManager.sharedManager.fetchArchiveNotes(for: lastEvalKey, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        //try to cancel queue for avatarImage if exist
                        //   SystemManager.avatarOperationQueue.cancelAllOperations()
                        DataUtilities.sharedManager.deleteNotes(archived: true)
                        
                        // TODO Delete Author and NoteGoals with notes count = 0
                        // CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    try NotesDataImpoter.sharedManager.extractUserNotes(response: responseObject!, archived: true)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
        })
        
    }
    
    
    // Unarchive A Note
    func unarchiveNote(_ messageId: String, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's Archive A Note API and Handle Response
        NetworkManager.sharedManager.unarchiveNote(messageId, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                if let unarchiveNoteResponseDictionary = responseObject as? Dictionary<String, Any> {
                    do {
                        try DataImporter.sharedManager.extractUnArchiveNoteData(parameters: unarchiveNoteResponseDictionary)
                        completion(responseObject, nil)
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        completion(responseObject, nserror)
                    }
                    return
                }
            }
            completion(responseObject, nil)
        })
        
    }
    
    
    // MARK: Get MyAccount Details with userId
    
    func getUserGoals(_ userId:Int, withAccessToken accessToken:String, isPulltoRefresh: Bool, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.getUserGoals(userId, usingAccessToken: accessToken, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                return
            }
            
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteGoals()
                        //  CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    try GoalsDataImpoter.sharedManager.extractUserGoals(responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
        })
        
    }
    
    // Goal Notes messages
    func fetchGoalNotes(for goalId: Int32, goalType: String, isPulltoRefresh: Bool, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's Notes unread messages API and Handle Response
        let lastEvalKey = isPulltoRefresh == true ? "" : DataUtilities.sharedManager.findGoalNotesLastEvalKey()
        
        NetworkManager.sharedManager.fetchGoalNotes(for: goalId, goalType: goalType, lastEvalKey: lastEvalKey, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
             CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
            do {
                if(isPulltoRefresh) {
                  DataUtilities.sharedManager.deleteGoalNotes(for: goalId)
                }
                try NotesDataImpoter.sharedManager.extractGoalNotes(response: responseObject!)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
                }
            }
        })
        
    }
    
    
    //MARK : Change goal status
    func changeGoalStatus(_ goalId:Int, withGoalType goalType:String,forStatus status:Int, withAccessToken accessToken:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.changeGoalStatus(goalId, withGoalType:goalType, forStatus: status, usingAccessToken: accessToken, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }
    
    //MARK : Get goal plan
    func getGoalPlan(_ planId:Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //Get Access Token
        let accessToken = KeychainManager.sharedManager.readAccessToken()
        
        NetworkManager.sharedManager.getGoalPlan(planId, usingAccessToken: accessToken, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                completion(responseObject, fetchError)
                return
            }
            completion(responseObject, nil)
        })
    }
    
    //MARK : AddNote API Call
    func addReplyGoalNote(_ userId:Int, withGoalId goalId:Int32, withPlanId planId: Int32?, withGoalType goalType:String, withMessageBody messageBody:String, withStatus status:Int32, withParentMessageId parentMessageId:String?, withNoteId noteId: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        var addReplyGoalNotePayload = [DictionaryKey.GoalNote.author: [DictionaryKey.GoalNote.id: userId],  DictionaryKey.GoalNote.goalId: goalId, DictionaryKey.GoalNote.goalType: goalType, DictionaryKey.GoalNote.messageBody: messageBody, DictionaryKey.GoalNote.status: status] as [String : Any]
        if planId != nil {
            addReplyGoalNotePayload[DictionaryKey.GoalNote.planId] = planId
        }
        if parentMessageId != "" {
            addReplyGoalNotePayload[DictionaryKey.GoalNote.parentMessageId] = parentMessageId
        }
        
        NetworkManager.sharedManager.addReplyGoalNote(withGoalId: goalId, withGoalType: goalType, withPayload: addReplyGoalNotePayload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    try NotesDataImpoter.sharedManager.extractSingleGoalNotes(response: responseObject!, noteId: noteId, parentMessageId: parentMessageId!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                completion(responseObject, nil)
            }
        })
    }
    
    
    //MARK : Get Avatar Image
    func fetchAvatarImage(_ userId:Int32, isGoalNote: Bool, withSize size:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //   SystemManager.avatarOperationQueue.addOperation {
        NetworkManager.sharedManager.fetchAvatarImage(userId, withSize:size, completion: {
            (responseObject, fetchError) in
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                if fetchError != nil {
                    NotesDataImpoter.sharedManager.saveAvatarImage(userId, isGoalNote: isGoalNote, withAvatar: nil)
                    completion(responseObject, fetchError)
                    CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    return
                }
                //save the avatar image to GoalAuthorEntity
                NotesDataImpoter.sharedManager.saveAvatarImage(userId, isGoalNote: isGoalNote, withAvatar: responseObject as? NSData)
                completion(responseObject, nil)
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
            }
        })
    }
    
    //MARK : Get Avatar Image
    func fetchProfileAvatarImage(_ userId:Int32, withSize size:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //  SystemManager.avatarOperationQueue.addOperation {
        NetworkManager.sharedManager.fetchAvatarImage(userId, withSize:size, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                completion(responseObject, fetchError)
                return
            }
            do {
                if let imageData = responseObject as? Data {
                    try DataImporter.sharedManager.extractProfileImage(imageData)
                    completion(responseObject, nil)
                } else {
                    
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
            
        })
    }
    
    
    //MARK: Channel Groups
    func channelGroups(_ userId:Int, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's forgotPassword API and Handle Response
        NetworkManager.sharedManager.channelGroups(userId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                completion(responseObject, fetchError)
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
              //  let channelGroupsResponseDictionary = responseObject as! [Dictionary<String, Any>]
                do {
                    try DataImporter.sharedManager.extractChannelGroups(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
        })
        
    }
    
    //MARK: Channel Groups For Messages
    func channelGroupsForMessages(_ userId:Int, pullToRefresh: Bool, isPubNub: Bool, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.channelGroups(userId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(pullToRefresh) {
                        //try to cancel queue for avatarImage if exist
                        DataUtilities.sharedManager.deleteMessages()
                    }
                   // let channelGroupsResponseDictionary = responseObject as! [Dictionary<String, Any>]
                    try ChannelGroupsDataImpoter.sharedManager.extractChannelGroups(parameters: responseObject, isPubNub: isPubNub)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
            
        })
        
    }
    
    //MARK : fetch single goal
    func fetchUserGoal(_ goalId:Int, withGoalType goalType:String, withAccessToken accessToken:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.fetchUserGoal(goalId, withGoalType:goalType, usingAccessToken: accessToken, completion: {
            (responseObject, fetchError) in
            
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            do {
                
                //create a dictionary with allGoals
                //add flag here
                if var streamGoal:Dictionary<String,Any>  = responseObject as? Dictionary<String,Any>
                {
                    streamGoal[GoalAccessType.isStreamGoalOnly] = true
                    let responseDict:Dictionary<String,Any> = ["allGoals":[streamGoal]]
                    try GoalsDataImpoter.sharedManager.extractUserGoals(responseDict)
                }
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }
    
    
    //MARK: Archived Messages
    func fetchArchivedMessages(_ channelId:Int32, pullToRefresh: Bool, loadAPI: Bool, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        var endKey : String
        if loadAPI {
            endKey = ""
        } else {
            if let getEndKey = DataUtilities.sharedManager.findMessageListEndKey(channelId) {
                endKey = pullToRefresh == true ? "" : getEndKey
            } else {
                endKey = pullToRefresh == true ? "" : ""
            }
        }
        
        //Call NetworkManager's forgotPassword API and Handle Response
        NetworkManager.sharedManager.fetchArchivedMessages(channelId, endKey: endKey, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                
              //  let messageListResponseDictionary = responseObject as! [Dictionary<String, Any>]
                do {
                    try MessageListDataImpoter.sharedManager.extractMessagesList(parameters: responseObject, channelID: channelId, loadAPI: loadAPI)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
        })
        
    }
    
    
    //MARK: Archived Messages
    func fetchReadMessages(_ channelId:Int32, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's forgotPassword API and Handle Response
        NetworkManager.sharedManager.fetchReadMessages(channelId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
            return
        })
        
    }
    
    //MARK : Get Avatar Image
    func fetchAvatarImageMessagesList(_ userId:Int32, withSize size:String, fromSearch: Bool, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //   SystemManager.avatarOperationQueue.addOperation {
        NetworkManager.sharedManager.fetchAvatarImage(userId, withSize:size, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                MessageListDataImpoter.sharedManager.saveAvatarImageMessgaeList(userId, withAvatar: nil, isSearch: fromSearch)
                completion(responseObject, fetchError)
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                return
            }
            //save the avatar image to GoalAuthorEntity
            MessageListDataImpoter.sharedManager.saveAvatarImageMessgaeList(userId, withAvatar: responseObject as? NSData, isSearch: fromSearch)
            completion(responseObject, nil)
            CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
        })
    }
    
    
    //MARK : fetch search reponse for Direct Message
    func fetchSearchResponseDirectMsg(_ searchResponse:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.fetchSearchStringForDirectMessages(searchResponse, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                let searchMessageResponseDictionary = responseObject as! Dictionary<String, Any>
                //print ("search response", searchMessageResponseDictionary)
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractResponseFromSearchStringInfo(parameters: searchMessageResponseDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
        })
    }
    
    //MARK : fetch response for create direct channel
    func fetchResponseCreateDirectChannel(_ userId:Int, andSearchUserId searchUserId:Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        let userIdArray = [userId, searchUserId]
        let nameString  = "\(userId)@\(searchUserId)"
        //  print (nameString);
        let addDirectChannelPayload = [DictionaryKey.CreateDirectChannel.name: nameString,  DictionaryKey.CreateDirectChannel.type: "DIRECT", DictionaryKey.CreateDirectChannel.groupType: "DIRECT", DictionaryKey.CreateDirectChannel.userIds: userIdArray, DictionaryKey.CreateDirectChannel.isVisible: true] as [String : Any]
        //  print (addDirectChannelPayload)
        
        NetworkManager.sharedManager.createDirectChannel(userId, andSearchUserId: searchUserId, withPayload: addDirectChannelPayload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                let createDirectChannelResponseDictionary = responseObject as! Dictionary<String, Any>
                //print ("search response", createDirectChannelResponseDictionary)
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractResponseCreateDirectChannel(parameters: createDirectChannelResponseDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
            }
        })
    }
    
    //MARK : fetch search reponse for Direct Message
    func fetchCurrentChannels(_ userId:Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.fetchCurrentChannels(userId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            do {
                //TODO
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }
    
    //MARK : AddMessage API Call
    func addMessageFetch(_ chnnelID:Int32, withDictionary payload: Dictionary<String, Any>, withchannelUuid id: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.addMessageFetch(withChannelId: chnnelID, withPayload: payload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    try MessageListDataImpoter.sharedManager.extractSingleMessag(response: responseObject!, channelUuid: id)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                completion(responseObject, nil)
            }
        })
    }
    
    //MARK : fetch search reponse for Direct Message
    func fetchSearchPeopleInRoomResponse(_ searchResponse:String,_ channelId:Int32, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.fetchUserIdsForPeopleInRoom(searchResponse, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            let searchMessageResponseDictionary = responseObject as? [Dictionary<String, Any>]
            do {
                try SearchPeopleInRoomDataImporter.sharedManager.extractResponseFromSearchStringInfo(parameters: searchMessageResponseDictionary!, channelId: channelId)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }
    
    //MARK : Get Avatar Image
    func fetchAvatarImagePeopleInRoom(_ userId:Int32, withSize size:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //   SystemManager.avatarOperationQueue.addOperation {
        NetworkManager.sharedManager.fetchAvatarImage(userId, withSize:size, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                SearchPeopleInRoomDataImporter.sharedManager.saveAvatarImagePeopleInRoom(userId, withAvatar: nil)
                completion(responseObject, fetchError)
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                return
            }
            //save the avatar image to GoalAuthorEntity
            SearchPeopleInRoomDataImporter.sharedManager.saveAvatarImagePeopleInRoom(userId, withAvatar: responseObject as? NSData)
            completion(responseObject, nil)
            CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
        })
    }
    
    
    //MARK : Leave DirectMessage
    func leaveDirectMessage(_ channelGroupId:Int32, withChannelId channelId: Int32, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        let leaveDirectMessagePayload = ["isHidden" : 1] as [String : Any]
        
        NetworkManager.sharedManager.leaveDirectMessage(channelGroupId, withChannelId: channelId, withPayload: leaveDirectMessagePayload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            // CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
            if let unarchiveNoteResponseDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractLeaveDirectMessgaeData(parameters: unarchiveNoteResponseDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            //}
            completion(responseObject, nil)
        })
    }
    
    
    //MARK : Rejoin DirectMessage
    func rejoinDirectMessage(_ channelGroupId:Int32, withChannelId channelId: Int32, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        let leaveDirectMessagePayload = ["isHidden" : 0] as [String : Any]
        
        NetworkManager.sharedManager.rejoinDirectMessage(channelGroupId, withChannelId: channelId, withPayload: leaveDirectMessagePayload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                if let unarchiveNoteResponseDictionary = responseObject as? Dictionary<String, Any> {
                    do {
                        try DataImporter.sharedManager.extractRejoinDirectMessgaeData(parameters: unarchiveNoteResponseDictionary)
                        completion(responseObject, nil)
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        completion(responseObject, nserror)
                    }
                    return
                }
            }
           // completion(responseObject, nil)
        })
    }
    
    //MARK : Settings
    func fetchSettings( completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.fetchSettings( completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let settingsDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractSettingsData(parameters: settingsDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }
    
    
    //MARK: Pinned Plan
    func fetchPinnedPlan(_ isPulltoRefresh: Bool, limit: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchPinnedPlan(limit, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    if(isPulltoRefresh) {
                        //try to cancel queue for avatarImage if exist
                        //   SystemManager.avatarOperationQueue.cancelAllOperations()
                        DataUtilities.sharedManager.deletePinnedPlans()
                        DataUtilities.sharedManager.deleteKPIPinnedPlans()
                        DataUtilities.sharedManager.deleteDataSeriesPinnedPlans()
                        
                        // TODO Delete Author and NoteGoals with notes count = 0
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try PinnedPlanDataImpoter.sharedManager.extractPinnedPlan(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    //MARK: Pinned Plan
    func fetchPinnedPlanForPeople(_ isPulltoRefresh: Bool, limit: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchPinnedPlanForPeople(limit, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    if(isPulltoRefresh) {
                        //try to cancel queue for avatarImage if exist
                        //   SystemManager.avatarOperationQueue.cancelAllOperations()
                        DataUtilities.sharedManager.deletePinnedPlans()
                        DataUtilities.sharedManager.deleteKPIPinnedPlans()
                        DataUtilities.sharedManager.deleteDataSeriesPinnedPlans()
                        
                        // TODO Delete Author and NoteGoals with notes count = 0
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try PinnedPlanDataImpoter.sharedManager.extractPinnedPlan(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }

    
    
    //MARK : Pinned Plan Details
    func fetchPinnedPlanDetails(_ planID: Int64, isPulltoRefresh: Bool, limit: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchPinnedPlanDetails(planID, limit: limit, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteKPIPinnedPlansDetailsByID(planID)
                        DataUtilities.sharedManager.deletePinnedPlanKPIListByID(planID)
                        
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    try PinnedPlanDetailsDataImpoter.sharedManager.extractPinnedPlanDetails(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    //MARK: - Actionitems
    func fetchActionItemsList(_ isPulltoRefresh: Bool, userID: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchActionItemsList(userID, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteActionItemLists()
                        DataUtilities.sharedManager.deleteGoalActionItemProfileImage()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try ActionItemeList.sharedManager.extractActionItemsList(parameters: responseObject!, isGoalActionItem: false)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK : - ActionitemCompleteOneByOne
    func fetchActionItemComplete(_ actionItemId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchActionItemComplete(actionItemId, progressCount: 100, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let completeActionItemDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: completeActionItemDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK : - CompletedActionitems //  pageNumber: Int, pageSize: Int,
    func fetchCompletedActionItemsList(_ isPulltoRefresh: Bool, userID: Int, pageNumber: Int, pageSize: Int,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchCompletedActionItemsList(userID, pageNumber: pageNumber, pageSize: pageSize, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteCompletedActionItemList()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try CompletedActionItems.sharedManager.extractCompletedActionItemsList(parameters: responseObject!, isFromGoalActionItem: false)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK : - CompletedActionitemIncompleteOneByOne
    func fetchCompletedActionItemIncomplete(_ actionItemId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchCompletedActionItemIncomplete(actionItemId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let completeActionItemDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: completeActionItemDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    //MARK : - CompletedActionitemcompleteOneByOne
    func fetchCompletedActionItemComplete(_ actionItemId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchCompletedActionItemcomplete(actionItemId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let completeActionItemDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: completeActionItemDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }

    
    //MARK : - GoalActionitems
    func fetchGoalActionItemsList(_ isPulltoRefresh: Bool, goalID: Int32, goalType: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchGoalActionItemsList(goalID, goalType: goalType, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteGoalActionItemLists()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try ActionItemeList.sharedManager.extractActionItemsList(parameters: responseObject!, isGoalActionItem: true)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK : Get Avatar Image Goal ActionItem
    func fetchAvatarImageGoalActionItem(_ userId:Int64, withSize size:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //   SystemManager.avatarOperationQueue.addOperation {
        NetworkManager.sharedManager.fetchAvatarImageGoalActionItem(userId, withSize:size, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                ActionItemeList.sharedManager.saveAvatarImageGoalActionItem(userId, withAvatar: nil)
                completion(responseObject, fetchError)
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                return
            }
            //save the avatar image to GoalAuthorEntity
            ActionItemeList.sharedManager.saveAvatarImageGoalActionItem(userId, withAvatar: responseObject as? NSData)
            completion(responseObject, nil)
            CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
        })
    }
    
    
    //MARK : - GoalCompletedActionitems //  pageNumber: Int, pageSize: Int,
    func fetchGoalCompletedActionItemsList(_ isPulltoRefresh: Bool, goalID: Int32, goalType: String, pageNumber: Int, pageSize: Int,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchGoalCompletedActionItemsList(goalID, goalType: goalType, pageNumber: pageNumber, pageSize: pageSize, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteGoalCompletedActionItemList()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try CompletedActionItems.sharedManager.extractCompletedActionItemsList(parameters: responseObject!, isFromGoalActionItem: true)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    //MARK: Perticular UserAccount Information
    
    // User Account Info
    func accountInfoUser(_ userId:Int64, completion : @escaping
        NetworkRetrieverDataTaskDidReceiveData){
        
        //Call NetworkManager's forgotPassword API and Handle Response
        NetworkManager.sharedManager.accountInfoUser(userId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            let userAccountInfoResponseDictionary = responseObject as! Dictionary<String, Any>
            do {
                try SingleUserInfoDataImpoter.sharedManager.extractSingleUserInfo(parameters: userAccountInfoResponseDictionary)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
        
    }
    
    
    //MARK : - ActionitemsDetails
    func fetchActionItemsDetails(_ isPulltoRefresh: Bool, userID: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchActionItemsDetails(userID, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteActionItemDetails()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try ActionItemeDetails.sharedManager.extractActionItemsDetails(parameters: responseObject!, isGoalActionItem: false)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK : - Actionitems Delete
    func fetchActionItemsDelete(_ actionItemID: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchActionItemsDelete(actionItemID, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let actionItemDeleteDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: actionItemDeleteDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }

    

    
    
    //MARK : - Update ActionItemDetail
    func fetchUpdatePercentageActionItemDetail(_ actionItemID: Int64, percentage: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchUpdatePercentageActionItemDetail(actionItemID, percentage: percentage,  completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let actionItemDeleteDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: actionItemDeleteDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }
    
    func fetchUpdateTitleTextActionItemDetail(_ actionItemID: Int64, title: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchUpdateTitleActionItemDetail(actionItemID, title: title,  completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let actionItemDeleteDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: actionItemDeleteDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }


    func fetchUpdateDescriptionTextActionItemDetail(_ actionItemID: Int64, description: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchUpdateDescriptionActionItemDetail(actionItemID, descriptionText: description,  completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let actionItemDeleteDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: actionItemDeleteDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }

    func fetchUpdateDueDateActionItemDetail(_ actionItemID: Int64, dueDate: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchUpdateDueDateActionItemDetail(actionItemID, dueDate: dueDate,  completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let actionItemDeleteDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: actionItemDeleteDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }
    
    
    //MARK : fetch Goal Assignee List
    func fetchAssigneeListResponse(_ goalId: Int32, goalType: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.fetchGoalAssigneeList(goalId, goalType: goalType, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
           // let searchMessageResponseDictionary = responseObject as? [String]
            do {
                try AssigneeListDataImporter.sharedManager.extractResponseFromAssigneeListInfo(parameters: responseObject!)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }
    
    
    //MARK : fetch Goal Assignee List
    func fetchUsersAccountAssigneeList(_ usersIds: [Int], goalId: Int32,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        //let convertedArray: [String] = usersIds.map{ String($0)}
        
       // let floatArray = [12, 14.6, 35]
        let stringArray = usersIds.flatMap { String($0) }
        let string = stringArray.joined(separator: ",")
        
        NetworkManager.sharedManager.fetchUsersAccountAssigneeList(string, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            // let searchMessageResponseDictionary = responseObject as? [String]
            do {
                try AssigneePeopleInRoomDataImporter.sharedManager.extractResponseFromSearchStringInfo(parameters: responseObject!, goalID: goalId)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }

    
    //MARK : Get Avatar Image For Assignee
    func fetchAvatarImageAssignee(_ userId:Int32, withSize size:String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //   SystemManager.avatarOperationQueue.addOperation {
        NetworkManager.sharedManager.fetchAvatarImage(userId, withSize:size, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                AssigneePeopleInRoomDataImporter.sharedManager.saveAvatarImagePeopleInRoom(userId, withAvatar: nil)
                completion(responseObject, fetchError)
                CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                return
            }
            //save the avatar image to GoalAuthorEntity
            AssigneePeopleInRoomDataImporter.sharedManager.saveAvatarImagePeopleInRoom(userId, withAvatar: responseObject as? NSData)
            completion(responseObject, nil)
            CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
        })
    }
    
    
    
    func fetchUpdateActionItemDetail(_ actionItemID: Int64, title: String, description: String, dueDate: String, assigneeId: Int, progress: Int, mode: ActionItemDetailMode, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        var actionItemDetailPayload = ["progress": progress] as [String : Any]
        switch mode {
        case .personal:
            actionItemDetailPayload["title"] = title
            actionItemDetailPayload["description"] = description
            actionItemDetailPayload["dueDate"] = dueDate
            break
        case .managerAssign:
            actionItemDetailPayload["title"] = title
            actionItemDetailPayload["description"] = description
            actionItemDetailPayload["dueDate"] = dueDate
            break
        case .goal:
            actionItemDetailPayload["title"] = title
            actionItemDetailPayload["description"] = description
            actionItemDetailPayload["dueDate"] = dueDate
            actionItemDetailPayload["user"] = assigneeId
            break
        case .meeting:
            actionItemDetailPayload["title"] = title
            actionItemDetailPayload["description"] = description
            actionItemDetailPayload["dueDate"] = dueDate
            break
        }
        
        NetworkManager.sharedManager.fetchUpdateActionItemDetail(actionItemID, payload: actionItemDetailPayload,  completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            if let actionItemDeleteDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try DataImporter.sharedManager.extractForgotPasswordData(parameters: actionItemDeleteDictionary)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            completion(responseObject, nil)
        })
    }
    
    func fetchCreateActionItem(_ payload: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
        NetworkManager.sharedManager.fetchCreateActionItem(payload,  completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
//                    if(isPulltoRefresh) {
//                        DataUtilities.sharedManager.deleteActionItemDetails()
//                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
//                    }
                    
                    try ActionItemeDetails.sharedManager.extractActionItemsDetails(parameters: responseObject!, isGoalActionItem: false)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK : fetch Goal Assignee List
    func fetchAssigneeListForManagerAssign(_ goalId: Int32, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        NetworkManager.sharedManager.fetchGoalManagerAssignAssigneeList(completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try SearchDirectMsgDataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            
            // let searchMessageResponseDictionary = responseObject as? [String]
            do {
                try AssigneePeopleInRoomDataImporter.sharedManager.extractResponseFromSearchStringInfo(parameters: responseObject!, goalID: goalId)
                completion(responseObject, nil)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                completion(responseObject, nserror)
            }
        })
    }
    
    
    //MARK: - HomeScreen Actionitems
    
    func fetchHomeActionItemsList(_ isPulltoRefresh: Bool, userID: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchActionItemsList(userID, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                //      if let pinnedPlanDictionary = responseObject as? Dictionary<String, Any> {
                do {
                    try SystemManager.sharedManager.extractActionItemsListForBudgeCount(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }

    
    //MARK : - MeetingSeriesList
    func fetchMeetingSeriesList(_ isPulltoRefresh: Bool, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        NetworkManager.sharedManager.fetchMeetingSeriesList( completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteMeetingSeries()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try MeetingSeriesList.sharedManager.extractMeetingSeriesList(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK: - Pending Meeting Instances
    func fetchPendingMeetingSeriesList(_ isPulltoRefresh: Bool, seriesId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){ // userId,seriesId, Pagestart, Pagesize
        NetworkManager.sharedManager.fetchPendingMeetingList(seriesId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deleteMeetingSeriesPaginated()
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try MeetingSeriesPaginated.sharedManager.extractMeetingSeriesPaginated(parameters: responseObject!, isCompleted: false, seriesId: seriesId)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }

    //MARK: - Completed Meeting Instances
    func fetchCompletedMeetingSeriesList(_ isPulltoRefresh: Bool, seriesId: Int64,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){ // userId,seriesId, Pagestart, Pagesize
        NetworkManager.sharedManager.fetchCompletedMeetingList(seriesId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        // DataUtilities.sharedManager.deleteMeetingSeries()
                       // CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try MeetingSeriesPaginated.sharedManager.extractMeetingSeriesPaginated(parameters: responseObject!, isCompleted: true, seriesId: seriesId)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK: - Meeting Detail
    func fetchMeetingDetail(_ isPulltoRefresh: Bool, meetingInstanceId: Int64,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){ // userId,seriesId, Pagestart, Pagesize
        NetworkManager.sharedManager.fetchMeetingDetail(meetingInstanceId, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                         DataUtilities.sharedManager.deleteMeetingInstantTopics()
                         DataUtilities.sharedManager.deleteActionItemLists()
                         CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try MeetingInstantTopics.sharedManager.extractMeetingInstantTopics(parameters: responseObject!, meetingInstanceId: meetingInstanceId)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
 
    //MARK: - People Search
    func fetchPeopleList(_ isPulltoRefresh: Bool, userId: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){ // userId,seriesId, Pagestart, Pagesize
        NetworkManager.sharedManager.fetchPeopleList(completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    if(isPulltoRefresh) {
                        DataUtilities.sharedManager.deletePeopleSearchList(Int32(userId))
                        CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    }
                    
                    try PeopleSearchListImporter.sharedManager.extractPeopleSearchList(parameters: responseObject!, userId: userId)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK: - People Search
    func fetchPeopleProfile(_ userID: Int64,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){ // userId,seriesId, Pagestart, Pagesize
        NetworkManager.sharedManager.fetchPeopleProfile(userID, completion: {
            (responseObject, fetchError) in
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                     DataUtilities.sharedManager.deletePeopleProfileDetail()
                    CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)

                    try PeopleProfileDetailImporter.sharedManager.extractPeopleProfileDetail(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }


    
    //MARK : AddProgress API Call
    func addProgressGoalNote(_ userId:Int, withGoalId goalId:Int32, withPlanId planId: Int32?, withGoalType goalType:String, withMessageBody messageBody:String, withParentMessageId parentMessageId:String?, withNoteId noteId: String, progress: Int32, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        var addReplyGoalNotePayload = [DictionaryKey.GoalNote.author: [DictionaryKey.GoalNote.id: userId],  DictionaryKey.GoalNote.goalId: goalId, DictionaryKey.GoalNote.goalType: goalType, DictionaryKey.GoalNote.messageBody: messageBody, DictionaryKey.GoalNote.progress: progress] as [String : Any]
        if planId != nil {
            addReplyGoalNotePayload[DictionaryKey.GoalNote.planId] = planId
        }
        if parentMessageId != "" {
            addReplyGoalNotePayload[DictionaryKey.GoalNote.parentMessageId] = parentMessageId
        }
        
        NetworkManager.sharedManager.progressGoalNote(withGoalId: goalId, withGoalType: goalType, withPayload: addReplyGoalNotePayload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    try NotesDataImpoter.sharedManager.extractSingleGoalNotes(response: responseObject!, noteId: noteId, parentMessageId: parentMessageId!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    //MARK : AddStatus API Call
    func addStatusGoalNote(_ userId:Int, withGoalId goalId:Int32, withPlanId planId: Int32?, withGoalType goalType:String, withMessageBody messageBody:String, withParentMessageId parentMessageId:String?, withNoteId noteId: String, withStatus status:Int32, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        var addReplyGoalNotePayload = [DictionaryKey.GoalNote.author: [DictionaryKey.GoalNote.id: userId],  DictionaryKey.GoalNote.goalId: goalId, DictionaryKey.GoalNote.goalType: goalType.lowercased(), DictionaryKey.GoalNote.messageBody: messageBody, DictionaryKey.GoalNote.status: status, DictionaryKey.GoalNote.parentMessageId: parentMessageId!] as [String : Any]
        if planId != nil {
            addReplyGoalNotePayload[DictionaryKey.GoalNote.planId] = planId
        }
        if parentMessageId == "" {
            addReplyGoalNotePayload[DictionaryKey.GoalNote.parentMessageId] = "0"
        } else {
             addReplyGoalNotePayload[DictionaryKey.GoalNote.parentMessageId] = parentMessageId
        }
        print(addReplyGoalNotePayload)
        NetworkManager.sharedManager.statusGoalNote(withGoalId: goalId, withGoalType: goalType, withPayload: addReplyGoalNotePayload, completion: {
            (responseObject, fetchError) in
            if fetchError != nil {
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    try NotesDataImpoter.sharedManager.extractSingleGoalNotes(response: responseObject!, noteId: noteId, parentMessageId: parentMessageId!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
    
    //MARK: - People Search
    func updateAttachedImage(_ goalId: Int32, goalType: String, imageData: UIImage,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){ // userId,seriesId, Pagestart, Pagesize
        NetworkManager.sharedManager.updateAttachedImage(goalId, goalType: goalType, data: imageData, completion: {
            (responseObject, fetchError) in
            print(responseObject)
            if fetchError != nil{
                do {
                    try DataImporter.sharedManager.extractError(error: fetchError!)
                    completion(nil, fetchError)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
            CoreDataStackManager.sharedManager.managedObjectContext.performAndWait {
                do {
                    DataUtilities.sharedManager.deletePeopleProfileDetail()
                    CoreDataStackManager.sharedManager.save(context: CoreDataStackManager.sharedManager.managedObjectContext)
                    
                    try PeopleProfileDetailImporter.sharedManager.extractPeopleProfileDetail(parameters: responseObject!)
                    completion(responseObject, nil)
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    completion(responseObject, nserror)
                }
                return
            }
        })
    }
    
}


