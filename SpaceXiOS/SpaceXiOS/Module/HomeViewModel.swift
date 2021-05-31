//
//  HomeViewModel.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 28/05/21.
//

import Foundation

struct ErrorContent {
    let errorMessage: String
    let action: (()->Void)?
}

protocol HomeViewRepresentable: class {
    // Output
    var title: String { get }
    var showError: (ErrorContent) -> Void { get set }
    var refreshUI: (APODDataModel) -> Void { get set }
    
    // Input
    func viewLoaded()
}

final class HomeViewModel: HomeViewRepresentable {
    let title: String = "Pic of the Day"
    var showError: (ErrorContent) -> Void = { _ in }
    var refreshUI: (APODDataModel) -> Void = { _ in }
    
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
                self?.refreshUI(dataModel)
            case .failure(let error):
                if let cachedData = self?.getCachedDataForDailyImage() {
                    self?.fetchedCachedResponseSuccessfully(cachedData, error: error)
                } else {
                    self?.showError(ErrorContent(errorMessage: error.genericErrorMessage, action: nil))
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
    
    private func fetchedCachedResponseSuccessfully(_ dataModel: APODDataModel, error: SpaceXAPIError) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if !dataModel.date.isTodaysDate(formatter: dateFormatter),
           case SpaceXAPIError.noInternetConnection = error {
            showError(ErrorContent(errorMessage: "We are not connected to the internet, showing you the last image we have.", action: nil))
        }
        
        self.refreshUI(dataModel)
    }
}
