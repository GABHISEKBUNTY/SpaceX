//
//  NetworkManager.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 28/05/21.
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

protocol NetworkManagable {
    @discardableResult func getSomeData<T: Decodable>(api: APIData, completion: @escaping (Result<T, SpaceXAPIError>)->Void) -> URLSessionTask?
    @discardableResult func getData(api: APIData, completion: @escaping (Result<Data, SpaceXAPIError>)->Void) -> URLSessionTask?
}

class NetworkManager: NetworkManagable {
    @discardableResult func getSomeData<T: Decodable>(api: APIData, completion: @escaping (Result<T, SpaceXAPIError>)->Void) -> URLSessionTask? {
        return getData(api: api) { apiResult in
            switch apiResult {
            case .success(let apiData):
                do {
                    let decodableModel: T = try decode(apiData)
                    completion(.success(decodableModel))
                } catch let decodableError {
                    completion(.failure(SpaceXAPIError.decodingError(decodableError)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @discardableResult func getData(api: APIData, completion: @escaping (Result<Data, SpaceXAPIError>)->Void) -> URLSessionTask? {
        guard let urlVal = URL(string: api.url) else {
            completion(.failure(SpaceXAPIError.invalidURL(api.url)))
            return nil
        }
        
        let request = URLRequest(url: urlVal, cachePolicy: api.cachePolicy)
        
        let sessionTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let apiError = error {
                completion(.failure(ErrorParser.mapServerErrorToAppError(apiError)))
            } else if let apiData = data {
                completion(.success(apiData))
            } else {
                completion(.failure(SpaceXAPIError.unknown))
            }
        }
        
        sessionTask.resume()
        
        return sessionTask
    }
    
}
