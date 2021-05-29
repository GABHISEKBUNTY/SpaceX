//
//  APODAPIService.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 29/05/21.
//

import Foundation

enum APODAPIService: APIData {
    case dailyImage
    
    var url: String {
        "https://api.nasa.gov/planetary/apod?api_key=4NRyn64FWY1VnGAtkRcufmfPSSEF78bi0hJbSJf8"
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        .reloadIgnoringCacheData
    }
}
