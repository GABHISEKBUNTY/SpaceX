//
//  HomeViewModel.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 28/05/21.
//

import Foundation

struct ErrorContent {
    let errorMessage: String
    let action: ()->Void
}

protocol HomeViewRepresentable: class {
    // Output
    var title: String { get }
    var showError: (ErrorContent) -> Void { get set }
    var refreshUI: (HomePresentationData) -> Void { get set }
    
    // Input
    func viewLoaded()
}

struct HomePresentationData {
    let url: String?
    let title: String
    let explanation: String
}

final class HomeViewModel: HomeViewRepresentable {
    let title: String = "Pic of the Day"
    var showError: (ErrorContent) -> Void = { _ in }
    var refreshUI: (HomePresentationData) -> Void = { _ in }
    
    private let networkManager: NetworkManagable
    
    init(networkManager: NetworkManagable = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func viewLoaded() {
        loadData()
    }
    
    private func loadData() {
        let apiResult: (Result<APODDataModel, SpaceXAPIError>) -> Void = { [weak self] apiData in
            switch apiData {
            case .success(let dataModel):
                print(dataModel)
            case .failure(let error):
                print(error)
            }
        }
        
        networkManager.getSomeData(api: APODAPIService.dailyImage, completion: apiResult)
    }
}
