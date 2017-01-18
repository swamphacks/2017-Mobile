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
  let school: String?
  let isVolunteer: Bool
}

extension UserInfo {
  init?(json: JSONDictionary) {
    guard let name = json["name"] as? String,
          let email = json["email"] as? String,
          let isVolunteer = json["volunteer"] as? Bool
    else {
      print("Failed to retrieve UserInfo from json \(json)")
      return nil
    }
    self.name = name
    self.email = email
    self.school = json["school"] as? String
    self.isVolunteer = isVolunteer
  }
  
  var json: JSONDictionary {
    return ["name": name, "email": email, "school": school ?? "", "volunteer": isVolunteer]
  }
}

extension FIRUser {
  
  static var infoCacheKey: String {
    return "user-info"
  }
  
  func prepareInfoIfNeeded() {
    if let cached = UserDefaults.standard.dictionary(forKey: FIRUser.infoCacheKey), let _ = UserInfo(json: cached) {
      return
    }
    getInfo(completion: nil)
  }
  
  func getInfo(useCache: Bool = true, completion: ((UserInfo?) -> Void)?) {
    if useCache, let cached = UserDefaults.standard.dictionary(forKey: FIRUser.infoCacheKey), let info = UserInfo(json: cached) {
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
      
      UserDefaults.standard.set(json, forKey: FIRUser.infoCacheKey)
      completion?(userInfo)
    }
  }
  
  static func purgeInfo() {
    UserDefaults.standard.set(nil, forKey: FIRUser.infoCacheKey)
  }
  
}

extension FIRUser {
  
   static var qrCodeCacheKey: String {
    return "user-qrCode"
  }
  
  func prepareQRCodeIfNeeded() {
    if let data = UserDefaults.standard.data(forKey: FIRUser.qrCodeCacheKey), let _ = UIImage(data: data) {
      return
    }
    getQRCode(completion: nil)
  }
  
  func getQRCode(useCache: Bool = true, completion: ((UIImage?) -> Void)?) {
    if useCache, let data = UserDefaults.standard.data(forKey: FIRUser.qrCodeCacheKey), let image = UIImage(data: data) {
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
    
    UserDefaults.standard.set(data, forKey: FIRUser.qrCodeCacheKey)
    
    completion?(qrCode)
  }
  
  static func purgeQRCode() {
    UserDefaults.standard.set(nil, forKey: FIRUser.qrCodeCacheKey)
  }
  
}
