//
//  Firebase.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import Foundation
import Firebase

typealias JSONDictionary = [String: Any]

public enum DataError: Error {
  case snapshotError
  case jsonError
}

public enum Result<A> {
  case success(A)
  case error(Error)
}

extension Result {
  public init(_ value: A?, or error: Error) {
    if let value = value {
      self = .success(value)
    } else {
      self = .error(error)
    }
  }
  
  public var value: A? {
    guard case .success(let v) = self else { return nil }
    return v
  }
}

struct FirebaseResource<A> {
  let path: String
  let parse: (FIRDataSnapshot) -> A?
}

extension FirebaseResource {
  
  init(path: String, parseJSON: @escaping (JSONDictionary) -> A?) {
    self.path = path
    self.parse = { snapshot in
      let json = snapshot.value as? JSONDictionary
      return json.flatMap(parseJSON)
    }
  }
  
}

final class FirebaseManager {
  
  static let shared = FirebaseManager()
  
  func load<A>(_ resource: FirebaseResource<A>, queryEventType: (FIRDatabaseReference) -> (FIRDatabaseQuery, FIRDataEventType), completion: @escaping (Result<A>) -> Void) {
    let ref = FIRDatabase.database().reference().child(resource.path)
    let (query, eventType) = queryEventType(ref)
    
    query.observeSingleEvent(of: eventType, with: { (snapshot) in
      let parsed = resource.parse(snapshot)
      let result = Result<A>(parsed, or: DataError.jsonError)
      
      DispatchQueue.main.async { completion(result) }
    })
  }
  
  func observe<A>(_ resource: FirebaseResource<A>, queryEventType: (FIRDatabaseReference) -> (FIRDatabaseQuery, FIRDataEventType), completion: @escaping (Result<A>) -> Void) -> UInt {
    let ref = FIRDatabase.database().reference().child(resource.path)
    let (query, eventType) = queryEventType(ref)
    
    let handle = query.observe(eventType, with: { (snapshot) in
      let parsed = resource.parse(snapshot)
      let result = Result<A>(parsed, or: DataError.jsonError)
      
      DispatchQueue.main.async { completion(result) }
    })
    
    return handle
  }

}
