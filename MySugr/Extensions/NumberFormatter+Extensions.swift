//
//  NumberFormatter+Extensions.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import Foundation

extension NumberFormatter {
    static let measurement: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter
    }()
}
