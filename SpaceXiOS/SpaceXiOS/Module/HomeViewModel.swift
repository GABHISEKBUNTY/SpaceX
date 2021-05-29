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
    
    private let apiService: APODAPIServiceable
    
    init(apiService: APODAPIServiceable = APODAPIService()) {
        self.apiService = apiService
    }
    
    func viewLoaded() {
        loadData()
    }
    
    private func loadData() {
        let apiResult: (Result<InMemoryData<APODDataModel>, SpaceXAPIError>) -> Void = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let inMemoryData):
                    self?.fetchedResponseSuccessfully(inMemoryData)
                case .failure:
                    return
                }
            }
        }
        
        apiService.getAPODData(completion: apiResult)
    }
    
    private func fetchedResponseSuccessfully(_ inMemoryData: InMemoryData<APODDataModel>) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if inMemoryData.isCached && !inMemoryData.data.date.isTodaysDate(formatter: dateFormatter) {
            self.showError(ErrorContent(errorMessage: "", action: nil))
        }
        
        self.refreshUI(inMemoryData.data)
    }
}
