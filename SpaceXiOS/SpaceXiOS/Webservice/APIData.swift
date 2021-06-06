//
//  APIData.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 29/05/21.
//

import Foundation

protocol APIData {
    var url: String { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension APIData {
    var cachePolicy: URLRequest.CachePolicy {
        .useProtocolCachePolicy
    }
}
