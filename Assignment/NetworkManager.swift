//
//  NetworkManager.swift
//  ETW
//
//  Created by Afshan Momin on 20/01/17.
//  Copyright © 2017 Ness Digital Engineering. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager: NSObject {
    
    static let sharedManager = NetworkManager()
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
    
    static let ErrorDomain = "com.etw.error.networking"
    
    //MARK: Authentication
    
    
    //Authenticate Login with companyId, username, password
    func authenticateLogin(_ emailId: String, withPassword password: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //1. Create downloadURL
        let apiPath = QueryParameters.Login
        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
        
        //2. Create httpHeaders
        let keys = [ NetworkingHeaders.ContentTypeHeaderField]
        let values = [NetworkingConstants.DataHeaderContentType]
        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
        
        //3. Create httpMethod based on API request type
        let httpMethod = HttpMethods.httpPOST
        
        //4. Request NetworkRetriever for performaing dataTask
        
        let payload = ["email": emailId, "password": password] as [String : Any]
       
        NetworkRetriever.sharedManager.performDataTask(
            for: url!,
            usingHttpMethod: httpMethod,
            usingHeaders:httpHeaders as! Dictionary,
            usingPayload:payload as Dictionary, //empty payload for login
            withTask: NetworkingTasks.loginTask + SystemManager.sharedManager.uniqueString(),
            completion: completion)
    }

}
    
//    //Authenticate Login with companyId, username, password
//    func authenticateLogin(_ companyId:String, withUsername username: String, withPassword password: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
//
//        //1. Create downloadURL
//        let apiPath = QueryParameters.userAccount + QueryParameters.login
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let loginString = String(format: "%@:%@", username, password)
//        let loginData = loginString.data(using: String.Encoding.utf8)!
//        let base64LoginString = loginData.base64EncodedString()
//        let keys = [NetworkingHeaders.AuthorizationHeaderField, NetworkingHeaders.ClientIDHeaderField, NetworkingHeaders.ContentTypeHeaderField]
//        let values = ["Basic \(base64LoginString)", companyId, NetworkingConstants.DataHeaderContentType]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod based on API request type
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [String: String]()
//
//
//
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:httpHeaders as! Dictionary,
//            usingPayload:payload as Dictionary, //empty payload for login
//            withTask: NetworkingTasks.loginTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: Forgot Password
//
//    //Forgotpassword with email ID
//    func forgotPassword(resetEmail email: String, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = QueryParameters.userAccount + QueryParameters.forgotPassword
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let keys = [NetworkingHeaders.ContentTypeHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Create emailPaylod
//        let emailPayload = NSDictionary.init(object:email, forKey:"email" as String as NSCopying)
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload:(emailPayload as NSDictionary) as! Dictionary<String, Any>, //Email Payload for forgot password
//            withTask: NetworkingTasks.resetPasswordTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: Sign Out
//
//    // Sign Out From User Account
//    func signOut(completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = QueryParameters.userAccount + QueryParameters.logOut
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, "Authorization = \(KeychainManager.sharedManager.readAccessToken())"]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpGET
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [String: String]()
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload: payload as Dictionary, //empty payload for LogOut
//            withTask: NetworkingTasks.signOutTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: User Account info
//
//    // User Account info
//    func userAccountInfo(_ userId:Int, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = QueryParameters.userAccount + String(format: QueryParameters.accountDetails, userId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieUserAccountHeaderField]
//        let values = [NetworkingConstants.DataHeaderContentType, "Authorization = \(KeychainManager.sharedManager.readAccessToken())"]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpGET
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [String: String]()
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload: payload as Dictionary,
//            withTask: NetworkingTasks.myAccountTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: Refresh
//
//    // Refresh JWT tokens
//    func refreshToken(completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = QueryParameters.userAccount + QueryParameters.refresh
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, "Authorization = \(KeychainManager.sharedManager.readAccessToken())"]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [ "access_token" : "\(KeychainManager.sharedManager.readAccessToken())",
//            "refresh_token" : "\(KeychainManager.sharedManager.readRefreshToekn())",
//            "auth_key" : "\(KeychainManager.sharedManager.readAuthKey())"]
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload: payload as Dictionary, //empty payload for LogOut
//            withTask: NetworkingTasks.refreshTokenTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//
//    //MARK: Notes
//
//    // fetch Notes unread messages
//    func fetchUnreadMessageNotes(for lastEvalKey: String?, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = QueryParameters.notesUnreadMessages
//        let pageStartKey = lastEvalKey == nil || lastEvalKey?.isEmpty == true ? "" : String(format: QueryParameters.pageStartKey, lastEvalKey!)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath + pageStartKey)
//        print(url)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Notes api
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.userNotesUnreadMessageTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)    }
//
//
//
//    // archive single note
//    func archiveNote(_ messageId: String,completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.archiveNote, messageId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.archiveNoteTask + SystemManager.sharedManager.uniqueString() + messageId,
//            completion: completion)    }
//
//
//    // archive All Notes
//    func archiveAllNotes(_ messageId: String,completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.archiveAllNotes, messageId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.archiveAllNotesTask + SystemManager.sharedManager.uniqueString() + messageId,
//            completion: completion)
//    }
//
//
//    //MARK: Notes Archive
//
//    // fetch Archive Notes List
//    func fetchArchiveNotes(for lastEvalKey: String?, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = QueryParameters.archiveNotesList
//        let pageStartKey = lastEvalKey == nil || lastEvalKey?.isEmpty == true ? "" : String(format: QueryParameters.pageStartKey, lastEvalKey!)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath + pageStartKey)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Notes api
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.userNotesUnreadMessageTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    // unarchive single note
//    func unarchiveNote(_ messageId: String,completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.unarchiveNote, messageId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//        let payload = [String: String]() //empty payload for Unarchive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.archiveNoteTask + SystemManager.sharedManager.uniqueString() + messageId,
//            completion: completion)
//    }
//
//
//    //MARK: Retrieve User Goals
//
//    func getUserGoals(_ userId:Int, usingAccessToken accessToken: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.userGoals, userId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, accessToken)
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for myaccount api
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.userGoalsTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    // fetch Goal Notes messages
//    func fetchGoalNotes(for goalId: Int32, goalType: String, lastEvalKey: String?, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.goalNotes, goalId, goalType)
//        let pageStartKey = lastEvalKey == nil || lastEvalKey?.isEmpty == true ? "" : String(format: QueryParameters.pageStartKey, lastEvalKey!)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath + pageStartKey)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Notes api
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.userNotesUnreadMessageTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)    }
//
//
//    //Mark: Change status of a goal
//    func changeGoalStatus(_ userId:Int, withGoalType goalType:String,forStatus status:Int, usingAccessToken accessToken: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.goalStatus, userId,goalType)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, accessToken)
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//        let goalStatusPayload = NSDictionary.init(object:status, forKey:"status" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:goalStatusPayload as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.changeGoalStatusTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //Mark: getGoalPlan
//    func getGoalPlan(_ planId:Int, usingAccessToken accessToken: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.goalPlan, planId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, accessToken)
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let goalStatusPayload = NSDictionary.init() //empty
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:goalStatusPayload as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.changeGoalStatusTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK : Add Note or Reply
//    //{author: {id: 1}, goalId: 190, goalType: “plan”, planId: 24, messageBody: “<p>I have something to say…</p>”, status: 0}
//    func addReplyGoalNote(withGoalId goalId:Int32, withGoalType goalType:String, withPayload payLoad: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.addGoalNote, goalId,goalType)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:payLoad,
//            withTask: NetworkingTasks.replyGoalNoteTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK : Get Avatar profile image for author
//    func fetchAvatarImage(_ userId:Int32, withSize size: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.fetchAvatarImage, userId, size)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let emptyPayload = NSDictionary.init() //empty
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:emptyPayload as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.avatarImageTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: Channel Groups
//    func channelGroups(_ userId:Int, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.channelGroups, userId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        print(url)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieUserAccountHeaderField]
//        let values = [NetworkingConstants.DataHeaderContentType, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpGET
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [String: String]()
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload: payload as Dictionary,
//            withTask: NetworkingTasks.myAccountTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //Mark: Fetch single goal
//    func fetchUserGoal(_ goalId:Int, withGoalType goalType:String, usingAccessToken accessToken: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.fetchUserGoal, goalId,goalType)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, accessToken)
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let goalStatusPayload = [String: String]()
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:goalStatusPayload as Dictionary<String, Any>,
//            withTask: NetworkingTasks.changeGoalStatusTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: Archived Messages
//    func fetchArchivedMessages(_ channelId:Int32, endKey: String?, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.archivedMessages, channelId)
//        //   let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        let paginationStartKey = endKey == nil || endKey?.isEmpty == true ? "" : String(format: QueryParameters.paginationStartKey, endKey!)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath + paginationStartKey + QueryParameters.messagesListCount)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpGET
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [String: String]()
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload: payload as Dictionary,
//            withTask: NetworkingTasks.archivedMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    // MARK: Read Messages
//    func fetchReadMessages(_ channelId:Int32, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.readMessages, channelId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpPUT
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [String: String]()
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload: payload as Dictionary,
//            withTask: NetworkingTasks.readMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: Search Direct Message
//    func fetchSearchStringForDirectMessages(_ searchString: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create downloadURL
//        let encodedHost = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let apiPath = String(format: QueryParameters.searchDirectMessages, encodedHost!)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.searchDirectMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //     MARK: Creating Direct Channel
//    func createDirectChannel(_ userId:Int, andSearchUserId searchUserId:Int, withPayload payLoad: Dictionary<String, Any>, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.createDirectChannel)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//        let payload = payLoad
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.createDirectChannel + SystemManager.sharedManager.uniqueString(),
//            completion: completion)    }
//
//
//    //     MARK: Retrieve Current Channels
//    func fetchCurrentChannels(_ userId: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.retriveCurrentChannels, userId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.searchDirectMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK : Add Message
//
//    func addMessageFetch(withChannelId channelId:Int32, withPayload payLoad: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.addMessage, channelId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        //  let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:payLoad,
//            withTask: NetworkingTasks.addMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: Search Poeple In Room
//    func fetchUserIdsForPeopleInRoom(_ userIds: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create downloadURL
//        //let encodedHost = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let apiPath = String(format: QueryParameters.searchPeopleInRoom, userIds)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.searchDirectMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK : Leave Direct Message <channelGroupId>, <channelId>
//    func leaveDirectMessage(_ channelGroupId:Int32, withChannelId channelId: Int32, withPayload payLoad: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.leaveDirectMessage, channelGroupId, channelId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payLoad ,
//            withTask: NetworkingTasks.leaveDirectMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK : Rejoin Direct Message <channelGroupId>, <channelId>
//    func rejoinDirectMessage(_ channelGroupId:Int32, withChannelId channelId: Int32, withPayload payLoad: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.leaveDirectMessage, channelGroupId, channelId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payLoad ,
//            withTask: NetworkingTasks.rejoinDirectMessagesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK : Settings
//    func fetchSettings( completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.settings)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.settingsTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK : Pinned Plan
//    func fetchPinnedPlan(_ limit: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//      //  let  apiPath = String(format: QueryParameters.pinnedPlan, limit)
//
//        var apiPath: String = ""
//        if SystemManager.sharedManager.isPeopleProfileSelected() {
//            apiPath = String(format: QueryParameters.pinnedPlanForPeople, SystemManager.sharedManager.checkUserID(),limit)
//        } else {
//            apiPath = String(format: QueryParameters.pinnedPlan, limit)
//        }
//
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.pinnedPlanTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK : Pinned Plan For People
//    func fetchPinnedPlanForPeople(_ limit: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        var apiPath: String = ""
//        if SystemManager.sharedManager.isPeopleProfileSelected() {
//             apiPath = String(format: QueryParameters.pinnedPlanForPeople, SystemManager.sharedManager.checkUserID())
//        } else {
//             apiPath = String(format: QueryParameters.pinnedPlan, limit)
//        }
//         apiPath = String(format: QueryParameters.pinnedPlanForPeople, SystemManager.sharedManager.checkUserID())
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.pinnedPlanForPeopleTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK : Pinned Plan Details
//    func fetchPinnedPlanDetails(_ planID: Int64, limit: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.pinnedPlanDetails, planID,limit)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.pinnedPlanDetailsTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: ActionItemsList
//    func fetchActionItemsList(_ userID: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemsList, userID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.actionItemsListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: ActionitemCompleteOneByOne
//    func fetchActionItemComplete(_ actionItemId: Int64, progressCount: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemComplete, actionItemId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object:progressCount, forKey:"progress" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.swapCompleteActionItemsListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: CompletedActionItemsList
//    func fetchCompletedActionItemsList(_ userID: Int, pageNumber: Int, pageSize: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.completedActionItemsList, userID,pageNumber,pageSize)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.completedActionItemsListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: CompletedActionitemIncompleteOneByOne
//    func fetchCompletedActionItemIncomplete(_ actionItemId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemComplete, actionItemId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object:false, forKey:"completed" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.completeActionItemsListIncompleteTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: CompletedActionitemcompleteOneByOne
//    func fetchCompletedActionItemcomplete(_ actionItemId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemComplete, actionItemId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object:true, forKey:"completed" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.completeActionItemsListCompleteTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//
//
//    //MARK: GoalActionItemsList
//    func fetchGoalActionItemsList(_ goalID: Int32, goalType: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.goalActionItemsList, goalID, goalType)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.goalActionItemsListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: GoalCompletedActionItemsList
//    func fetchGoalCompletedActionItemsList(_ goalID: Int32, goalType: String, pageNumber: Int, pageSize: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.goalCompletedActionItemsList, goalID,goalType,pageNumber,pageSize)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.completedActionItemsListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//
//    //MARK : Get Avatar profile image for GoalActionItem
//    func fetchAvatarImageGoalActionItem(_ userId:Int64, withSize size: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.fetchAvatarImage, userId, size)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let emptyPayload = NSDictionary.init() //empty
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:emptyPayload as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.avatarGoalActionItemImageTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: Perticular User Account info
//
//    // Perticular User Account info
//    func accountInfoUser(_ userId:Int64, completion:@escaping NetworkRetrieverDataTaskDidReceiveData){
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.singleUserInfo, userId)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieUserAccountHeaderField]
//        let values = [NetworkingConstants.DataHeaderContentType, "Authorization = \(KeychainManager.sharedManager.readAccessToken())"]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//        //3. Create httpMethod
//        let httpMethod = HttpMethods.httpGET
//
//        //4. Request NetworkRetriever for performaing dataTask
//        let payload = [String: String]()
//
//        //5. Request NetworkRetriever for performing dataTask
//        NetworkRetriever.sharedManager.performDataTask(
//            for: url!,
//            usingHttpMethod: httpMethod,
//            usingHeaders:(httpHeaders as NSDictionary) as! Dictionary<String, String>,
//            usingPayload: payload as Dictionary,
//            withTask: NetworkingTasks.singleUserTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: ActionItemsDetails
//    func fetchActionItemsDetails(_ userID: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, userID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.actionItemsDetailsTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: ActionItemsDelete
//    func fetchActionItemsDelete(_ actionItemID: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, actionItemID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpDELETE
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.actionItemsDeleteTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: ActionItemsDelete
//    func fetchUpdateActionItemDetail(_ actionItemID: Int64, tag: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, actionItemID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object:false, forKey:"completed" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.actionItemsDeleteTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: fetchUpdatePercentageActionItemDetail
//    func fetchUpdatePercentageActionItemDetail(_ actionItemID: Int64, percentage: Int, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, actionItemID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object: percentage, forKey: "progress" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.actionItemsUpdatePercentageTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: fetchUpdateTitleTextActionItemDetail
//    func fetchUpdateTitleActionItemDetail(_ actionItemID: Int64, title: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, actionItemID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object: title, forKey: "title" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.actionItemsUpdateTitleTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: fetchUpdateTitleTextActionItemDetail
//    func fetchUpdateDescriptionActionItemDetail(_ actionItemID: Int64, descriptionText: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, actionItemID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object: descriptionText, forKey: "description" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.actionItemsUpdateDescriptionTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: fetchUpdateDueDateActionItemDetail
//    func fetchUpdateDueDateActionItemDetail(_ actionItemID: Int64, dueDate: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, actionItemID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//        let payload = NSDictionary.init(object: dueDate, forKey: "dueDate" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload as! Dictionary<String, Any> ,
//            withTask: NetworkingTasks.actionItemsUpdateDateTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: Assignee Goal List
//    func fetchGoalAssigneeList(_ goalId: Int32, goalType: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create downloadURL
//        //let encodedHost = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let apiPath = String(format: QueryParameters.actionItemAssigneeList, goalId,goalType)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieUserAccountHeaderField]
//        let values = [NetworkingConstants.DataHeaderAcceptCharset, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.actionItemsAssigneeListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: Assignee Goal List
//    func fetchUsersAccountAssigneeList(_ userIds: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create downloadURL
//        let apiPath = String(format: QueryParameters.actionItemAssigneeUserList, userIds)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.actionItemsUsersAccountAssigneeListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: fetchUpdateDueDateActionItemDetail
//    func fetchUpdateActionItemDetail(_ actionItemID: Int64, payload: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.actionItemDetails, actionItemID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPATCH
//
//      //  let payload = NSDictionary.init(object: dueDate, forKey: "dueDate" as String as NSCopying)
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.actionItemsUpdateDateTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: fetchUpdateDueDateActionItemDetail
//    func fetchCreateActionItem(_ payload: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.createActionItem)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.createActionItemsTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: Assignee ManagerAssign List
//    func fetchGoalManagerAssignAssigneeList(completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create downloadURL
//        //let encodedHost = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let apiPath = String(format: QueryParameters.manageAssignAssigneeList)
//        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:(payload as NSDictionary) as! Dictionary<String, Any>,
//            withTask: NetworkingTasks.actionItemsAssigneeListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: MeetingSeriesList
//    func fetchMeetingSeriesList( completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.meetingSeriesList, KeychainManager.sharedManager.readUserID())
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]() //empty payload for Archive Single Note
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.meetingSeriesTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: - PendingMeetingInstances
//
//    func fetchPendingMeetingList( _ seriesId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.pendingMeetingList, KeychainManager.sharedManager.readUserID(),seriesId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]()
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.pendingMeetingTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: - CompletedMeetingInstances
//
//    func fetchCompletedMeetingList( _ seriesId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.completedMeetingList, KeychainManager.sharedManager.readUserID(),seriesId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]()
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.completedMeetingTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: - MeetingDetail
//
//    func fetchMeetingDetail( _ meetingInstanceId: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.meetingDetailTopics, meetingInstanceId)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]()
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.meetingDetailTopicsTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    //MARK: - PeopleSearch List
//
//    func fetchPeopleList( completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.searchPeopleList, SystemManager.sharedManager.checkUserID())
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        print(url)
//        print(SystemManager.sharedManager.checkUserID())
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]()
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.peopleSearchListTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK: - PeopleProfile
//
//    func fetchPeopleProfile(_ userID: Int64, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.peopleProfile, userID)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpGET
//
//        let payload = [String: String]()
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload: payload ,
//            withTask: NetworkingTasks.peopleProfileTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//
//    //MARK : Progress Goal Note
//    //{author: {id: 1}, goalId: 190, goalType: “plan”, planId: 24, messageBody: “<p>I have something to say…</p>”, status: 0}
//    func progressGoalNote(withGoalId goalId:Int32, withGoalType goalType:String, withPayload payLoad: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.addGoalNote, goalId,goalType)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:payLoad,
//            withTask: NetworkingTasks.progressGoalNoteTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//    //MARK : Status Goal Note
//    //{author: {id: 1}, goalId: 190, goalType: “plan”, planId: 24, messageBody: “<p>I have something to say…</p>”, status: 0}
//    func statusGoalNote(withGoalId goalId:Int32, withGoalType goalType:String, withPayload payLoad: Dictionary<String, Any>, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.addGoalNote, goalId,goalType.lowercased())
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let companyID = KeychainManager.sharedManager.readCompanyId(); //Make sure that companyID stored in keychain after successful login
//        let keys = [NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.ClientIDHeaderField,NetworkingHeaders.CookieUserAccountHeaderField]
//        let values = [NetworkingConstants.DataHeaderAccept, companyID,authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTask(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders:httpHeaders as! Dictionary<String, String>,
//            usingPayload:payLoad,
//            withTask: NetworkingTasks.statusGoalNoteTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    }
//
//
//    func updateAttachedImage(_ goalId: Int32, goalType: String, data: UIImage, completion : @escaping NetworkRetrieverDataTaskDidReceiveData) {
//
//        let parameters = [
//            "id" : goalId
//            //"messageBody" : goalText
//            ] as [String : Any]
//
//
//        //1. Create download URL
//        let apiPath = String(format: QueryParameters.attachedImage, goalId, goalType)
//        let url     = URL.init(string: NetworkingConstants.baseURL() + apiPath)
//
//        let boundaryString = self.generateBoundaryString()
//        let file = self.createRequestBodyWith(parameters: parameters as! [String : NSObject], filePathKey: "files", boundary: boundaryString, image: data)
//
//        //2. Create httpHeaders
//        let authAccessTokenHeader = String(format: "%@=%@", NetworkingConstants.BasicAuthorization, KeychainManager.sharedManager.readAccessToken())
//        let keys = [NetworkingHeaders.ContentTypeHeaderField,"Content-Length", NetworkingHeaders.CookieHeaderField]
//
//        let values = ["multipart/form-data; boundary=\(boundaryString)","\(file.count)", authAccessTokenHeader]
//        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
//
//        print("httpHeaders =====> ",httpHeaders)
//        //3. Create httpMethod Request type
//        let httpMethod = HttpMethods.httpPOST
//
//       // let payload = [String: String]()
//        let dictionary: Dictionary<String, String> = [:]
//        //4. Invoke NetworkRetriever performDataTask
//        //Perform Data Task
//        NetworkRetriever.sharedManager.performDataTaskFormData(
//            for:url!,
//            usingHttpMethod:httpMethod,
//            usingHeaders: httpHeaders as! Dictionary<String, String>,
//            usingPayload: file ,//self.createRequestBodyWith(parameters: parameters as! [String : NSObject], filePathKey: "files", boundary: boundaryString, image: data) ,
//           // usingPayload: imageData! as NSData,
//
//            withTask: NetworkingTasks.peopleProfileTask + SystemManager.sharedManager.uniqueString(),
//            completion: completion)
//    } // multipart/form-data; boundary=----WebKitFormBoundaryLWHRJriTbB6IfTmc
//
//
//
//
//    func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String, image: UIImage) -> Data{
//
//        var body = NSMutableData()
//        let lineBreak = "\r\n"
//
//        for (key, value) in parameters {
//            body.append(string: "--\(boundary + lineBreak)")
//            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
//            body.append(string: "\(value)\r\n")
//        }
////
////        body.appendString(string: "--\(boundary)\r\n")
//        // let imageData = UIImagePNGRepresentation(image)
//        // let image = UIImage(data: data)
//      //  if image.count > 0 {
//        //  for i in 0..<(image.count) {
//
//        let mimetype = "image/jpeg"
//        let defFileName = self.generaterandomNumber() + ".png"
//        let imageData = SystemManager.sharedManager.compressImage(image: image)
//        var imageSize: Int = imageData!.count
//        print("size of image in KB: %f ", Double(imageSize) / 1024.0)
//        body.append(string: "--\(boundary + lineBreak)")
//        body.append(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\(lineBreak)")
//        body.append(string: "Content-Type: \(mimetype + lineBreak + lineBreak)")
//        body.append(imageData!)
//        body.append(string:  "\(lineBreak)")
//        body.append(string:  "--\(boundary) -- \(lineBreak)")
//        print("body Check =======", body)
//        return body as Data
//
////        let dataDecoded : Data = Data(base64Encoded: imageData!, options: .ignoreUnknownCharacters)!
////        print("dataDecoded =====", dataDecoded)
//
////        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
////        print("strBase64 =====", strBase64)
//
//       // body.append("Content-Disposition:form-data; name=\"files\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//
////         body.append("--\(boundary + lineBreak)")
////         body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\(lineBreak)")
////      //  body.appendString(string: "Content-Disposition: form-data; key=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
////// "multipart/form-data; boundary=\(boundaryString)"
////         body.append("Content-Type: \(mimetype + lineBreak + lineBreak)")
////
////       // body.append(strBase64!.data(using: .utf8)!)
////         body.append(imageData)
////      //  body.appendString(string: "\r\n")
////    //    body.appendString(string: "------\(boundary)--\r\n")
////         print("body Check =======", body)
////      //  print("String Check =======", String(data: body as Data, encoding: .utf32)!)
////        return body as Data
//    }
//    //  }
//
//
//  //  }
//
//    func generaterandomNumber() -> String {
//        let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
//      //  let randomTime:TimeInterval = TimeInterval(randomNum)
//        return String(randomNum) //string works too
//    }
//
//    func generateBoundaryString() -> String {
//        return "Boundary-\(NSUUID().uuidString)"
//    }
//
//}
//
//extension NSMutableData {
//
//    func append(string: String) {
//        if let data = string.data(using: String.Encoding.utf8) {
//            append(data)
//        }
//    }
//}
