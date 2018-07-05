//
//  Result.swift
//  Venew
//
//  Created by Masai Young on 7/5/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import Foundation

enum Result<Type, E: Error> {
    case Success(Type)
    case Failure(E)
}
