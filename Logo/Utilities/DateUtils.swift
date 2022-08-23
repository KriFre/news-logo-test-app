//
//  DateUtils.swift
//  Logo
//
//  Created by Kristaps Freibergs on 16/08/2022.
//

import Foundation

extension String {
    func toNewsApiDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toNewsApiDateString() -> String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: self)
    }
}
