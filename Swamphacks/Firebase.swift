//
//  Firebase.swift
//  Swamphacks
//
//  Created by Gonzalo Nunez on 12/25/16.
//  Copyright © 2016 Gonzalo Nunez. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

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
  let parse: (JSONDictionary) -> A?

  init(path: String, parse: @escaping (JSONDictionary) -> A?) {
    self.path = path
    self.parse = parse
  }
}

struct Firebase {
  let url: URL
  
  func load<A>(_ resource: FirebaseResource<A>, completion: @escaping (Result<A>) -> Void) {
    let resourceURL = url.appendingPathComponent(resource.path)
    
    
  }

}
