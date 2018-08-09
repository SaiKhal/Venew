//
//  Result.swift
//  Venew
//
//  Created by Masai Young on 7/5/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
    
    var value: T? {
        guard case let .success(val) = self else { return nil }
        return val
    }
    
    var error: Error? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
    
    func map<U>(_ transform: (T) -> (U)) -> Result<U,Error> {
        return flatMap { (value) -> Result<U, Error> in
            return .success(transform(value))
        }
    }
    
    func flatMap<U>(_ transform: (T) -> Result<U,Error>) -> Result<U,Error> {
        switch self {
            case let .success(value): return transform(value)
            case let .failure(error): return .failure(error)
        }
    }
    
        
}
