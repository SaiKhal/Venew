//
//  Data+Codable.swift
//  Venew
//
//  Created by Masai Young on 7/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case jsonDecoderError
}

extension Data {
    func convertTo<T: Codable>(type: T.Type) -> Result<T,NetworkingError> {
        do {
            let object = try JSONDecoder().decode(type, from: self)
            return .success(object)
        } catch {
            print(#function, "Error converting type \(type)\n", error)
            return .failure(.jsonDecoderError)
        }
    }
}
