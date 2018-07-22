//
//  Data+Codable.swift
//  Venew
//
//  Created by Masai Young on 7/19/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

extension Data {
    func convertTo<T: Codable>(type: T.Type) -> T? {
        do {
            let object = try JSONDecoder().decode(type, from: self)
            return object
        } catch {
            print(error)
            return nil
        }
    }
}
