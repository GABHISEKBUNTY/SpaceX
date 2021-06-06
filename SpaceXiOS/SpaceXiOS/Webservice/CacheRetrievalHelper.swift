//
//  CacheRetrievalHelper.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 05/06/21.
//

import Foundation

protocol CacheRetrievable {
    func getCachedDataForAPI<T: Decodable>(_ api: APIData) -> T?
}

struct CacheRetrievalHelper: CacheRetrievable {
    func getCachedDataForAPI<T: Decodable>(_ api: APIData) -> T? {
        guard let urlVal = URL(string: api.url) else {
            return nil
        }
        
        let urlRequest = URLRequest(url: urlVal)
        if let cachedData = URLCache.shared.cachedResponse(for: urlRequest)?.data {
            return try? decode(cachedData)
        }
        
        return nil
    }
}
