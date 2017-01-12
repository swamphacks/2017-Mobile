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
  
  fileprivate var infoCacheKey: String {
    return "\(uid)-info"
  }
  
  func prepareInfoIfNeeded() {
    if let cached = UserDefaults.standard.dictionary(forKey: infoCacheKey), let _ = UserInfo(json: cached) {
      return
    }
    getInfo(completion: nil)
  }
  
  func getInfo(useCache: Bool = true, completion: ((UserInfo?) -> Void)?) {
    if useCache, let cached = UserDefaults.standard.dictionary(forKey: infoCacheKey), let info = UserInfo(json: cached) {
      completion?(info)
      return
    }
    
    guard let email = email else {
      completion?(nil)
      return
    }
    
    
    FirebaseManager.shared.getInfo(forUserEmail: email) { userInfo in
      guard let json = userInfo?.json else {
        completion?(nil)
        return
      }
      
      UserDefaults.standard.set(json, forKey: self.infoCacheKey)
      completion?(userInfo)
    }
  }
  
  func purgeInfo() {
    UserDefaults.standard.set(nil, forKey: infoCacheKey)
  }
  
}

extension FIRUser {
  
  fileprivate var qrCodeCacheKey: String {
    return "\(uid)-qrCode"
  }
  
  func prepareQRCodeIfNeeded() {
    if let data = UserDefaults.standard.data(forKey: qrCodeCacheKey), let _ = UIImage(data: data) {
      return
    }
    getQRCode(completion: nil)
  }
  
  func getQRCode(useCache: Bool = true, completion: ((UIImage?) -> Void)?) {
    if useCache, let data = UserDefaults.standard.data(forKey: qrCodeCacheKey), let image = UIImage(data: data) {
      completion?(image)
      return
    }
    
    guard let email = email else {
      completion?(nil)
      return
    }
    
    guard let qrCode = QRGenerator(metadata: email).qrCode(), let data = UIImageJPEGRepresentation(qrCode, 1) else {
      completion?(nil)
      return
    }
    
    UserDefaults.standard.set(data, forKey: qrCodeCacheKey)
    
    completion?(qrCode)
  }
  
  func purgeQRCode() {
    UserDefaults.standard.set(nil, forKey: qrCodeCacheKey)
  }
  
}
