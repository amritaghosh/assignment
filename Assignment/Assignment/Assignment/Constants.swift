//
//  Constant.swift
//  Assignment
//
//  Created by Amrita Ghosh on 05/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

typealias NetworkRetrieverDownloadTaskDidWriteDataBlock = (Int64, Int64, Int64) -> Swift.Void
typealias NetworkRetrieverDataTaskDidReceiveData = (Any?, NSError?) -> Swift.Void
public typealias AlertBarAction = () -> Swift.Void
public typealias ActionSheetHandler = (Bool) -> Swift.Void
public typealias CompletionHandler = () -> Swift.Void

let kScreenHeight_iPhone5x: CGFloat                 =  568.0
let kScreenHeight_iPhoneX: CGFloat                  =  812.0


// Set Environment for API
let currentEnvironment: Environments = Environments.Development

enum Environments {
    case Development
}


struct NetworkingConstants {
    static let DataHeaderContentType    = "application/json; charset=utf-8"
    static let baseURLDevelopment       = "http://13.233.218.85"
   
    static func baseURL() -> String {
        switch currentEnvironment {
        case .Development:
            return NetworkingConstants.baseURLDevelopment
        }
    }
}


struct NetworkingHeaders {
    static let ContentTypeHeaderField      = "Content-Type"
    static let TokenHeaderField            = "token"
}

struct HttpMethods{
    static let httpGET      = "GET"
    static let httpPOST     = "POST"
}

struct QueryParameters {
    static let login                   = "/api/user/login"
    static let playerList              = "/api/players"
    static let filter                  = "/api/players/filters"
    
}

struct NetworkingTasks {
    static let loginTask                        = "LoginTask"
    static let playerListTask                   = "PlayerListTask"
    static let filterTask                       = "FlterTask"
    
}

struct StoryboardName {
    static let playerList = "PlayerList"
    static let authentication = "Authentication"
}

struct StoryboardIdentifier {
    static let playerListViewController       = "kPlayerListViewController"
    static let loadingViewController          = "kLoadingViewController"
}

struct AlertMessages {
    struct Authentication {
        static let badCredentials = "Please check your login credentials."
    }
}

struct JsonKeys {
    struct Errors {
        static let type             = "error"
    }
}

struct JwtKeys {
    static let userID               = "userId"
}

public enum AuthenticationCell: Int {
    case username
    case password
    case signIn
}

struct Validation {
    struct AuthenticationMinimumCharacterCount {
        static let username      =  1
        static let password      =  5
    }
}

struct AlertActionButton {
    static let ok           =  "OK"
}


struct UserDefaultKeys {
      static let loginToken    = "LoginToken"
}

struct ImageObserverKey {
    static let imageRecieved       = "ImageRecieved"
}


struct Server {
    static let error       = "Could not interpret data from the server."
}



