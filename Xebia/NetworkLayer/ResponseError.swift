//
//  ResponseError.swift
//  Weather
//
//  Created by Muhammad Farooq on 13/05/2020.
//  Copyright © 2020 Muhammad Farooq. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
}
