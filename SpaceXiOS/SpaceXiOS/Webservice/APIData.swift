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

extension APIData {
    func getCachedData() -> Data? {
        guard let urlVal = URL(string: url) else {
            return nil
        }
        
        let urlRequest = URLRequest(url: urlVal)
        return URLCache.shared.cachedResponse(for: urlRequest)?.data
    }
}
