//
//  StringExtensions.swift
//  SpaceXiOS
//
//  Created by G Abhisek on 29/05/21.
//

import Foundation

extension String {
    func isTodaysDate(formatter: DateFormatter) -> Bool {
        if let date = formatter.date(from: self) {
            return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day)
        }
        
        return true
    }
}
