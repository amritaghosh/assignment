//
//  NetworkRetriever.swift
//  Assignment
//
//  Created by Amrita Ghosh on 05/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import Foundation
import UIKit

class NetworkRetriever : NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    static let sharedManager = NetworkRetriever()
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
    // MARK:
    var session = URLSession()
    
    // response dictionary
    var recievedDataDictionary = Dictionary<String, Data>()
    // completion handlers dictonary
    var dataTaskCompletionHandlers = Dictionary<String, NetworkRetrieverDataTaskDidReceiveData>()
    
    
    lazy var backgroundSession: URLSession = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        self.session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil) //OperationQueue.main
        return self.session
    }()
    
    // MARK: Generic Perform Data Task
    func performDataTask(for downloadURL: URL, usingHttpMethod httpMethod : String, usingHeaders httpHeaders:Dictionary<String,String>,usingPayload jsonPayload : Dictionary<String,Any>, withTask taskDescription: String, completion: @escaping NetworkRetrieverDataTaskDidReceiveData) {
        
        self.session = self.backgroundSession
        self.dataTaskCompletionHandlers[taskDescription] = completion
        
        /*
         Create a new download task using the URL session. Tasks start in the “suspended” state; to start a task you need to explicitly call -resume on a task after creating it.
         */
        var mutableURLRequest = URLRequest.init(url: downloadURL)
        mutableURLRequest.httpMethod = httpMethod
        //Add all headers at once
        mutableURLRequest.allHTTPHeaderFields = httpHeaders
        //Set httpBody for POST / PUT / DELETE / PATCH but not for GET
        if (JSONSerialization.isValidJSONObject(jsonPayload) && httpMethod != "GET") {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonPayload, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                mutableURLRequest.httpBody = jsonData
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               // AlertsManager.sharedManager.enqueueAlert(Alerts.genericError)
            }
        }
        let dataTask = self.session.dataTask(with: mutableURLRequest)
        dataTask.taskDescription = taskDescription
        
        dataTask.resume()
    }
    
    
    // MARK: Generic Perform Data Task
    func performDataTaskFormData(for downloadURL: URL, usingHttpMethod httpMethod : String, usingHeaders httpHeaders:Dictionary<String,String>,usingPayload jsonPayload : Data, withTask taskDescription: String, completion: @escaping NetworkRetrieverDataTaskDidReceiveData) {
        
        self.session = self.backgroundSession
        self.dataTaskCompletionHandlers[taskDescription] = completion
        
        /*
         Create a new download task using the URL session. Tasks start in the “suspended” state; to start a task you need to explicitly call -resume on a task after creating it.
         */
        var mutableURLRequest = URLRequest.init(url: downloadURL)
        mutableURLRequest.httpMethod = httpMethod
        //Add all headers at once
        mutableURLRequest.allHTTPHeaderFields = httpHeaders
        
        if (JSONSerialization.isValidJSONObject(jsonPayload) && httpMethod != "GET") {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonPayload, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                mutableURLRequest.httpBody = jsonData
                
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //                let nserror = error as NSError
                //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               // AlertsManager.sharedManager.enqueueAlert(Alerts.genericError)
            }
        } else {
            mutableURLRequest.httpBody = jsonPayload as Data
        }
        let dataTask = self.session.dataTask(with: mutableURLRequest)
        dataTask.taskDescription = taskDescription
        
        dataTask.resume()
    }
    
    
    // MARK: URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        //handle with completion handler
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if let responseData = self.recievedDataDictionary[dataTask.taskDescription!] {
            var mutableResponseData = responseData
            mutableResponseData.append(data)
            self.recievedDataDictionary[dataTask.taskDescription!] = mutableResponseData
        }
        else {
            self.recievedDataDictionary[dataTask.taskDescription!] = data
        }
        
    }
    
    
    
    // MARK: URLSessionTaskDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if ((error) != nil) {
            let errorDescription = String.init(format: "Error!!! %@", (error?.localizedDescription)!)
            if let taskDescription = task.taskDescription {
                if let completionHandler = self.dataTaskCompletionHandlers[taskDescription] {
                    completionHandler(errorDescription,  error as NSError?)
                }
                if self.recievedDataDictionary.count > 0 {
                    self.recievedDataDictionary.removeValue(forKey: taskDescription)
                }
                self.dataTaskCompletionHandlers.removeValue(forKey: taskDescription)
                return
            }
          }
        
        if let taskDescription = task.taskDescription {
            if let data = self.recievedDataDictionary[taskDescription] {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    self.dataTaskCompletionHandlers[taskDescription]!(responseObject, nil)
                } catch {
                    //Replace this implementation with code to handle the error appropriately.
                    //fatalError() causes the application to generate a crash log and terminate.You should not use this function in a shipping application, although it may be useful during development.
                    self.recievedDataDictionary.removeValue(forKey: taskDescription)//???
                    self.dataTaskCompletionHandlers[taskDescription]!("Error!!!", NSError(domain: NetworkManager.ErrorDomain, code: 401, userInfo: ["message" : "Error!!!"]))
                    self.dataTaskCompletionHandlers.removeValue(forKey: taskDescription)
                    return
                }
                
                self.recievedDataDictionary.removeValue(forKey: taskDescription)
                self.dataTaskCompletionHandlers.removeValue(forKey: taskDescription)
                return
                
            }
            self.dataTaskCompletionHandlers[taskDescription]!("Error!!!", NSError(domain: NetworkManager.ErrorDomain, code: 401, userInfo: ["message" : "Error!!!"]))
            self.dataTaskCompletionHandlers.removeValue(forKey: taskDescription)
            return
        }
        
    }
    
    /*
     If an application has received an -application:handleEventsForBackgroundURLSession:completionHandler: message, the session delegate will receive this message to indicate that all messages previously enqueued for this session have been delivered. At this time it is safe to invoke the previously stored completion handler, or to begin any internal updates that will result in invoking the completion handler.
     */
    
    
    // MARK: URLSessionDelegate
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    }
    
    
}
