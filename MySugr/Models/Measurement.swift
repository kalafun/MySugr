//
//  Measurement.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import Foundation
import SwiftData

@Model
class Measurement: Hashable {
    var id: UUID
    var value: Float
    var date: Date

    init(id: UUID = .init(), value: Float, date: Date = Date()) {
        self.id = id
        self.value = value
        self.date = date
    }
}

extension Measurement {
    static func mocked(count: Int) -> [Measurement] {
        (0..<count).compactMap { index in
            Measurement(value: Float.random(in: 0...20))
        }
    }
}
