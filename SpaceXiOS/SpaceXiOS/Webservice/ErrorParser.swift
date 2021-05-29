//
//  ErrorParser.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 29/05/21.
//

import Foundation

enum SpaceXAPIError: Error {
    case invalidURL(String)
    case serverError(Error)
    case decodingError(Error)
    case noInternetConnection
    case unknown
    
    var genericErrorMessage: String {
        switch self {
        case .noInternetConnection:
            return "There seems to be some problem with your internet."
        default:
            return "We are working on it. Be right back"
        }
    }
}

struct ErrorParser {
    static func mapServerErrorToAppError(_ error: Error) -> SpaceXAPIError {
        if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
            return SpaceXAPIError.noInternetConnection
        } else {
            return SpaceXAPIError.serverError(error)
        }
    }
}
