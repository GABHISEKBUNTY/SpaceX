//
//  MockNetworkManager.swift
//  SpaceXiOSTests
//
//  Created by G Abhisek on 06/06/21.
//

import Foundation
@testable import SpaceXiOS

class MockNetworkManager<X>: NetworkManagable {
    var decodedResponseToReturn: Result<X, SpaceXAPIError>?
    var dataToReturn: Result<Data, SpaceXAPIError>?
    
    func getSomeData<T>(api: APIData, completion: @escaping (Result<T, SpaceXAPIError>) -> Void) -> URLSessionTask? where T : Decodable {
        if let decodedResponseToReturn = decodedResponseToReturn as? Result<T, SpaceXAPIError> {
            completion(decodedResponseToReturn)
            return nil
        }
        
        completion(.failure(SpaceXAPIError.unknown))
        return nil
    }
    
    func getData(api: APIData, completion: @escaping (Result<Data, SpaceXAPIError>) -> Void) -> URLSessionTask? {
        if let dataToReturn = dataToReturn {
            completion(dataToReturn)
            return nil
        }
        
        completion(.failure(SpaceXAPIError.unknown))
        return nil
    }
}
