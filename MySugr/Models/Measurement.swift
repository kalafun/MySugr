//
//  Measurement.swift
//  MySugr
//
//  Created by Tomas Bobko on 27.09.24.
//

import Foundation

struct Measurement: Hashable {
    let id = UUID()
    let value: Float
    let date = Date()
}

extension Measurement {
    static func mocked(count: Int) -> [Measurement] {
        (0..<count).compactMap { index in
            Measurement(value: Float.random(in: 0...20))
        }
    }
}
