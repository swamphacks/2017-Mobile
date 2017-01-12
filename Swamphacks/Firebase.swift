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

extension FirebaseResource where A: RangeReplaceableCollection {
  init(path: String, parseElement: @escaping (JSONDictionary) -> A.Iterator.Element?) throws {
    self = FirebaseResource(path: path, parse: { snapshot in
      guard let jsonDicts = snapshot.value as? [JSONDictionary] else { return nil }
      let result = jsonDicts.flatMap(parseElement)
      return A(result)
    })
  }
}

final class FirebaseManager {
  
  static let shared = FirebaseManager()
  
  func load<A>(_ resource: FirebaseResource<A>,
            queryEventType: (FIRDatabaseReference) -> (FIRDatabaseQuery, FIRDataEventType),
            completion: @escaping (Result<A>) -> Void)
  {
    return query(resource, queryEventType: queryEventType, query: _load, completion: completion)
  }
  
  func observe<A>(_ resource: FirebaseResource<A>,
               queryEventType: (FIRDatabaseReference) -> (FIRDatabaseQuery, FIRDataEventType),
               completion: @escaping (Result<A>) -> Void) -> Void
  {
    return query(resource, queryEventType: queryEventType, query: _observe, completion: completion)
  }
  
  fileprivate func query<A>(_ resource: FirebaseResource<A>,
                         queryEventType: (FIRDatabaseReference) -> (FIRDatabaseQuery, FIRDataEventType),
                         query: (FIRDatabaseQuery, FIRDataEventType, @escaping (FIRDataSnapshot) -> Void) -> Void,
                         completion: @escaping (Result<A>) -> Void) -> Void
  {
    let ref = FIRDatabase.database().reference().child(resource.path)
    let (q, eventType) = queryEventType(ref)
    query(q, eventType) { (snapshot) in
      let parsed = resource.parse(snapshot)
      let result = Result<A>(parsed, or: DataError.jsonError)
      DispatchQueue.main.async { completion(result) }
    }
  }
  
  // Soooooo I can't (entirely) functionally remove the duplicate code here that's up there ▲ because of ambiguity on Firebase's end...
  // They seem to define an observe(eventType:with:) function (and others) for both references and queries (which I still don't know why they do, but it sucks)
  // Stopped me from passing in those function handlers as parameters. Had to wrap some Firebase functions because of this but it removed the duplicate code.
  
  //MARK: Wrappers
  
  fileprivate func _load(query: FIRDatabaseQuery, eventType: FIRDataEventType, completion: @escaping (FIRDataSnapshot) -> Void) -> Void {
    query.observeSingleEvent(of: eventType, with: completion)
  }
  
  fileprivate func _observe(query: FIRDatabaseQuery, eventType: FIRDataEventType, completion: @escaping (FIRDataSnapshot) -> Void) -> Void {
    query.observe(eventType, with: completion)
  }
  
}

extension FirebaseManager {
  
  func getInfo(forUserEmail email: String, completion: @escaping (UserInfo?) -> Void) {
    let emailKey = email.replacingOccurrences(of: "@", with: "").replacingOccurrences(of: ".", with: "")
    
    let resource = FirebaseResource<UserInfo>(path: "confirmed/\(emailKey)", parseJSON: UserInfo.init)
    FirebaseManager.shared.load(resource, queryEventType: {($0, .value)}) { result in
      completion(result.value)
    }
  }
  
}
