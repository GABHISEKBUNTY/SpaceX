//
//  MockCacheRetrievableHelper.swift
//  SpaceXiOSTests
//
//  Created by G Abhisek on 06/06/21.
//

import Foundation
@testable import SpaceXiOS

class MockCacheRetrievableHelper<X>: CacheRetrievable {
    var decodedModelToReturn: X?
    
    func getCachedDataForAPI<T>(_ api: APIData) -> T? where T : Decodable {
        if let decodedModelToReturn = decodedModelToReturn as? T {
            return decodedModelToReturn
        }
        
        return nil
    }
}
