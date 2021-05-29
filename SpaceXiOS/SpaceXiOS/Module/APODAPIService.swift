//
//  APODAPIService.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 29/05/21.
//

import Foundation

enum APODAPIData: APIData {
    case dailyImage
    
    var url: String {
        "https://api.nasa.gov/planetary/apod?api_key=4NRyn64FWY1VnGAtkRcufmfPSSEF78bi0hJbSJf8"
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        .reloadIgnoringCacheData
    }
}

protocol APODAPIServiceable {
    func getAPODData(completion: @escaping (Result<InMemoryData<APODDataModel>, SpaceXAPIError>)->Void)
}

class APODAPIService: APODAPIServiceable {
    private let networkManager: NetworkManagable
    
    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getAPODData(completion: @escaping (Result<InMemoryData<APODDataModel>, SpaceXAPIError>)->Void) {
        let apiResult: (Result<APODDataModel, SpaceXAPIError>) -> Void = { [weak self] apiData in
            switch apiData {
            case .success(let dataModel):
                completion(.success(InMemoryData(data: dataModel, isCached: false)))
            case .failure(let error):
                if case SpaceXAPIError.noInternetConnection = error,
                   let cachedData = self?.getCachedDataForDailyImage() {
                    completion(.success(InMemoryData(data: cachedData, isCached: true)))
                } else {
                    completion(.failure(error))
                }
            }
        }
        
        networkManager.getSomeData(api: APODAPIData.dailyImage, completion: apiResult)
    }
    
    private func getCachedDataForDailyImage() -> APODDataModel? {
        if let cachedData = APODAPIData.dailyImage.getCachedData() {
            return try? decode(cachedData)
        }
        
        return nil
    }
}
