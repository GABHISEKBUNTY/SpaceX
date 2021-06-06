//
//  HomeViewModelTests.swift
//  SpaceXiOSTests
//
//  Created by G Abhisek on 31/05/21.
//

import XCTest
@testable import SpaceXiOS

func getExpectedErrorData(for apiError: SpaceXAPIError, isCachedDataAvailable: Bool) -> ErrorContent  {
    switch (apiError, isCachedDataAvailable) {
    case (.noInternetConnection, true):
        return ErrorContent(errorMessage: "We are not connected to the internet, showing you the last image we have.", action: nil)
        
    case (.noInternetConnection, false):
        return ErrorContent(errorMessage: "There seems to be some problem with your internet.", action: nil)
    default:
        return ErrorContent(errorMessage: "We are working on it. Be right back", action: nil)
    }
}

class HomeViewModelTests: XCTestCase {
    let successDataModel = APODDataModel(date: "2020-01-29", explanation: "This is some space", title: "Pic of the day", url: "https://hitme")
    var sut: HomeViewModel!

    func testTitle() throws {
        sut = HomeViewModel(networkManager: MockNetworkManager<APODDataModel>())
        XCTAssertEqual(sut.title, "Pic of the Day")
    }
    
    func testAPISuccess() throws {
        let networkManager = MockNetworkManager<APODDataModel>()
        networkManager.decodedResponseToReturn = Result.success(successDataModel)
            
        sut = HomeViewModel(networkManager: networkManager)
        
        sut.refreshUI = { responseDataModel in
            XCTAssertEqual(responseDataModel, self.successDataModel)
        }
        
        sut.showError = { errorContent in
            XCTFail("Error content should not be called in case of an API success")
        }
        
        sut.viewLoaded()
    }
    
    func testAPIFailureWithNoCachedData() {
        let networkManager = MockNetworkManager<APODDataModel>()
            
        sut = HomeViewModel(networkManager: networkManager, cacheRetrievalHelper: MockCacheRetrievableHelper<Any>())
        
        sut.refreshUI = { responseDataModel in
            XCTFail("Refresh UI should not be called if its an error and there is no cache")
        }
        
        func assertAPIError(error: SpaceXAPIError, isCachedDataAvailable: Bool) {
            sut.showError = { errorContent in
                let expectedErrorData = getExpectedErrorData(for: error, isCachedDataAvailable: isCachedDataAvailable)
                XCTAssertEqual(errorContent, expectedErrorData)
            }
        }
        
        for error in SpaceXAPIError.allErrors {
            networkManager.decodedResponseToReturn = Result.failure(error)
            assertAPIError(error: error, isCachedDataAvailable: false)
            sut.viewLoaded()
        }
    }
    
    func testAPIFailureWithCachedData() {
        let networkManager = MockNetworkManager<APODDataModel>()
        let cacheHelper = MockCacheRetrievableHelper<APODDataModel>()
            
        sut = HomeViewModel(networkManager: networkManager, cacheRetrievalHelper: cacheHelper)
        
        func assert(error: SpaceXAPIError, isCachedDataAvailable: Bool, isCachedTodayDate: Bool) {
            var date: String {
                if !isCachedTodayDate { return "2020-01-29" }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                return dateFormatter.string(from: Date())
            }
            
            cacheHelper.decodedModelToReturn = APODDataModel(date: date, explanation: "This is some space", title: "Pic of the day", url: "https://hitme")
                
            sut.refreshUI = { responseDataModel in
                XCTAssertEqual(responseDataModel, APODDataModel(date: date, explanation: "This is some space", title: "Pic of the day", url: "https://hitme"))
            }
            
            networkManager.decodedResponseToReturn = Result.failure(error)
            sut.showError = { errorContent in
                if case SpaceXAPIError.noInternetConnection = error, !isCachedTodayDate {
                    let expectedErrorData = getExpectedErrorData(for: error, isCachedDataAvailable: isCachedDataAvailable)
                    XCTAssertEqual(errorContent, expectedErrorData)
                } else {
                    XCTFail("Show error should not be called in case of other api error except no Internet connection.")
                }
            }
        }
        
        func checkForAllErrors(isCachedTodayDate: Bool) {
            for error in SpaceXAPIError.allErrors {
                networkManager.decodedResponseToReturn = Result.failure(error)
                assert(error: error, isCachedDataAvailable: true, isCachedTodayDate: isCachedTodayDate)
                sut.viewLoaded()
            }
        }
        
        checkForAllErrors(isCachedTodayDate: true)
        checkForAllErrors(isCachedTodayDate: false)
    }

}

extension SpaceXAPIError {
    static var allErrors: [SpaceXAPIError] {
        [.noInternetConnection, .unknown, .decodingError(SpaceXAPIError.unknown), .invalidURL(""), .serverError(SpaceXAPIError.unknown)]
    }
}
