//
//  Extensions.swift
//  BETA
//
//  Created by Ryan RK on 17/11/2021.
//

import Foundation

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
