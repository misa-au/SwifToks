//
//  IGUser.swift
//  SwifToks
//
//  Created by Pivotal Dev Floater 70 on 2015-12-05.
//  Copyright © 2015 misa. All rights reserved.
//

import Foundation
import SwiftyJSON

class IGUser {
    var id: String
    var username: String
    var profilePicture: String
    var bio: String
    var website: String
    var mediaCount: Int
    var followsCount: Int
    var followedByCount: Int
    
    init(json: JSON) {
        id = json["id"].stringValue
        username = json["username"].stringValue
        profilePicture = json["profile_picture"].stringValue
        bio = json["bio"].stringValue
        website = json["website"].stringValue
        let count = json["counts"].dictionary
        guard count != nil else {
            mediaCount = 0
            followsCount = 0
            followedByCount = 0
            return
        }
        mediaCount = (count?["media"]?.int)!
        followsCount = (count?["follows"]?.int)!
        followedByCount = (count?["followed_by"]?.int)!
    }
}