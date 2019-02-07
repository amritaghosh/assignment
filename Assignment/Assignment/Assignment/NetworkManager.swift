//
//  NetworkManager.swift
//  Assignment
//
//  Created by Amrita Ghosh on 05/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager: NSObject {
    
    static let sharedManager = NetworkManager()
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
    
    static let ErrorDomain = "com.assignment.error.networking"
    
    //MARK: Authentication
    
    
    //Authenticate Login with companyId, username, password
    func authenticateLogin(_ emailId: String, withPassword password: String, completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //1. Create downloadURL
        let apiPath = QueryParameters.login
        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
        
        //2. Create httpHeaders
        let keys = [ NetworkingHeaders.ContentTypeHeaderField]
        let values = [NetworkingConstants.DataHeaderContentType]
        let httpHeaders = NSDictionary.init(objects: values, forKeys: keys as [NSCopying])
        
        //3. Create httpMethod based on API request type
        let httpMethod = HttpMethods.httpPOST
        
        //4. Request NetworkRetriever for performaing dataTask
        
     //   let payload = ["email": "maheshwari@techcetra.com", "password": "qwerty123"] as [String : Any]
        let payload = ["email": emailId, "password": password] as [String : Any]

        
        NetworkRetriever.sharedManager.performDataTask(
            for: url!,
            usingHttpMethod: httpMethod,
            usingHeaders:httpHeaders as! Dictionary,
            usingPayload:payload as Dictionary, //empty payload for login
            withTask: NetworkingTasks.loginTask + SystemManager.sharedManager.uniqueString(),
            completion: completion)
    }
    
    func fetchPlayerList(_ payLoad: Dictionary<String, Any>,  completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //1. Create downloadURL
        let apiPath = QueryParameters.playerList
        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
        
        //2. Create httpHeaders
        let keys = [ NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.TokenHeaderField]
        let values = [NetworkingConstants.DataHeaderContentType, SystemManager.sharedManager.getToken()]
        let httpHeaders = NSDictionary.init(objects: values as [Any], forKeys: keys as [NSCopying])
        
        //3. Create httpMethod based on API request type
        let httpMethod = HttpMethods.httpPOST
        
        //4. Request NetworkRetriever for performaing dataTask
        
        NetworkRetriever.sharedManager.performDataTask(
            for: url!,
            usingHttpMethod: httpMethod,
            usingHeaders:httpHeaders as! Dictionary,
            usingPayload:payLoad as Dictionary, //empty payload for login
            withTask: NetworkingTasks.playerListTask + SystemManager.sharedManager.uniqueString(),
            completion: completion)
    }
    
    func fetchFilterData( completion : @escaping NetworkRetrieverDataTaskDidReceiveData){
        
        //1. Create downloadURL
        let apiPath = QueryParameters.filter
        let url = URL.init(string: NetworkingConstants.baseURL() + apiPath)
        
        //2. Create httpHeaders
        let keys = [ NetworkingHeaders.ContentTypeHeaderField, NetworkingHeaders.TokenHeaderField]
        let values = [NetworkingConstants.DataHeaderContentType, SystemManager.sharedManager.getToken()]
        let httpHeaders = NSDictionary.init(objects: values as [Any], forKeys: keys as [NSCopying])
        
        //3. Create httpMethod based on API request type
        let httpMethod = HttpMethods.httpGET
        
        //4. Request NetworkRetriever for performaing dataTask
        let payload = [String: String]()
        
        NetworkRetriever.sharedManager.performDataTask(
            for: url!,
            usingHttpMethod: httpMethod,
            usingHeaders:httpHeaders as! Dictionary,
            usingPayload:payload as Dictionary,
            withTask: NetworkingTasks.filterTask + SystemManager.sharedManager.uniqueString(),
            completion: completion)
    }
}
