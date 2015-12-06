//
//  DataController.swift
//  SwifToks
//
//  Created by Pivotal Dev Floater 70 on 2015-12-05.
//  Copyright © 2015 misa. All rights reserved.
//

import Foundation
import BrightFutures

class DataController {

    static let sharedInstance = DataController();
    private init() {
        
    }
    
    var user: IGUser?
    var media: Array<IGMedia>?
    
    func initialFetch() {
        self.userProfile()
        self.userPosts()
    }
    
    func userProfile() -> Future<IGUser, NSError> {
        let promise = Promise<IGUser, NSError>()
        NetworkClient.sharedInstance.userProfile(nil)
            .onSuccess{igUser in
                self.user = igUser as IGUser
                promise.success(self.user!)
            }.onFailure{error in
                promise.failure(error)
        }
        return promise.future
    }
    
    func userPosts() -> Future<Array<IGMedia>, NSError> {
        let promise = Promise<Array<IGMedia>, NSError>()
        NetworkClient.sharedInstance.userPosts(nil)
            .onSuccess{igMediaArray in
                self.media = igMediaArray as Array<IGMedia>
                promise.success(self.media!)
            }.onFailure{error in
                promise.failure(error)
        }
        return promise.future
    }
}
