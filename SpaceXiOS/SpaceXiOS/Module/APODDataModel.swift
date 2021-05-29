//
//  APODDataModel.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 29/05/21.
//

import Foundation

struct APODDataModel: Codable {
    let date, explanation: String
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date, explanation
        case title, url
    }
}
