//
//  UserInfo.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 1/11/17.
//  Copyright © 2017 Gonzalo Nunez. All rights reserved.
//

import UIKit
import Firebase

struct UserInfo {
  let name: String
  let email: String
  let school: String
  let isVolunteer: Bool
}

extension UserInfo {
  init?(json: JSONDictionary) {
    guard let name = json["name"] as? String,
          let email = json["email"] as? String,
          let school = json["school"] as? String,
          let isVolunteer = json["volunteer"] as? Bool
    else {
      print("Failed to retrieve UserInfo from json \(json)")
      return nil
    }
    self.name = name
    self.email = email
    self.school = school
    self.isVolunteer = isVolunteer
  }
  
  var json: JSONDictionary {
    return ["name": name, "email": email, "school": school, "volunteer": isVolunteer]
  }
}

extension FIRUser {
  
  var cacheKey: String {
    return "\(uid)-info"
  }
  
  func getInfo(useCache: Bool = true, completion: @escaping (UserInfo?) -> Void) {
    guard let email = email else {
      completion(nil)
      return
    }
    
    if useCache, let cached = UserDefaults.standard.dictionary(forKey: cacheKey), let info = UserInfo(json: cached) {
      completion(info)
      return
    }
    
    FirebaseManager.shared.getInfo(forUserEmail: email) { userInfo in
      guard let json = userInfo?.json else {
        completion(nil)
        return
      }
      
      UserDefaults.standard.set(json, forKey: self.cacheKey)
      completion(userInfo)      
    }
  }
  
  func purgeInfo() {
    UserDefaults.standard.set(nil, forKey: cacheKey)
  }
  
}
