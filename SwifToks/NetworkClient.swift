//
//  NetworkClient.swift
//  SwifToks
//
//  Created by Pivotal Dev Floater 70 on 2015-12-05.
//  Copyright © 2015 misa. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures
import SwiftyJSON

extension Error: ErrorType {}

class NetworkClient {
    
    static let sharedInstance = NetworkClient();
    private init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        _accessToken = defaults.stringForKey(kAccessTokenKey)
    }
    
    let kClientId = "d44c7bae370e47b2a1b2d8e86b5ab038"
    let kRedirectURI = "http://swiftoks.com"
    let kClientSecret = "9a73935c3a444fdf8b393e9d2c031870"
    let kAccessTokenKey = "kAccessTokenKey"
    let accessTokenParameterKey = "access_token"
    let instagramHost = "https://api.instagram.com/v1"
    let usersEndpoint = "/users/"
    let mediaEndpoint = "/media/"
    
    
    private var _accessToken: String?
    
    func instagramAuthURL() -> NSURL {
        let authEndpoint = String(format: "https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", arguments: [kClientId, kRedirectURI])
        let url = NSURL(string: authEndpoint)
        return url!;
    }
    
    func handleInstagramRedirect(redirectURL: NSURL) {
        let range = redirectURL.absoluteString.rangeOfString(accessTokenParameterKey)
        _accessToken = redirectURL.absoluteString.substringFromIndex((range?.endIndex)!)
        
        guard _accessToken != nil else {
            return
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(_accessToken, forKey: kAccessTokenKey)
        
    }
    
    func hasSession() -> Bool {
        return _accessToken != nil;
    }
    
    func userProfile(userid: String?) -> Future<IGUser, NSError> {
        let path = userid != nil ? userid : "self"
        let promise = Promise<IGUser, NSError>()
        executeGet(instagramHost + usersEndpoint + path!, parameters: nil)
            .onSuccess { returnedJson in
                let igUser = IGUser.init(json: returnedJson["data"])
                promise.success(igUser)
            }.onFailure { error in
                promise.failure(error)
            }
        return promise.future
    }
    
    func userPosts(userid: String?) -> Future<Array<IGMedia>, NSError> {
        let path = userid != nil ? userid : "self"
        let promise = Promise<Array<IGMedia>, NSError>()
        executeGet(instagramHost + usersEndpoint + path! + "/media/recent", parameters: nil)
            .onSuccess { returnedJson in
                let postsRaw = returnedJson["data"].arrayValue
                let posts = postsRaw.map {
                    post -> IGMedia in
                    let media = IGMedia(theJson: post)
                    return media
                }
                promise.success(posts)
            }.onFailure { error in
                promise.failure(error)
        }
        return promise.future
    }
    
    func executeGet(endpoint: String, var parameters : [String : AnyObject]?) -> Future<JSON, NSError> {
        if (parameters == nil) {
            parameters = [String : AnyObject]()
        }
        parameters![accessTokenParameterKey] = _accessToken
        
        let promise = Promise<JSON, NSError>()
        Alamofire.request(.GET, endpoint, parameters: parameters, encoding:.URL , headers: nil)
            .validate().responseJSON {response in
                
                
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                
                switch response.result {
                case .Success:
                if let value = response.result.value {
                let json = JSON(value)
                print("JSON: \(json)")
                    promise.success(json)
                }
                case .Failure(let error):
                print(error)
                    promise.failure(response.result.error!)
                }
                
        }
        
        return promise.future
    }
}