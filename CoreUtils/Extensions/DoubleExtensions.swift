//
//  DoubleExtensions.swift
//  VideoEditor
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation

public extension Double {
    func prettyString() -> String {
        if self == Double(Int(self)) {
            return "\(Int(self))"
        } else {
            return "\(self)"
        }
    }

    func prettyString(numberDigit: Int) -> String {
        if self == Double(Int(self)) {
            return "\(Int(self))"
        } else {
            let format = "%.0\(numberDigit)f"
            return String.init(format: format, self)
        }
    }

    func round(digit: Int) -> Double {
        let multipler = pow(10, Double(digit))

        return (self * multipler).rounded() / multipler
    }

    func floorWith(digit: Int) -> Double {
        let multipler = pow(10, Double(digit))

        return floor(self * multipler) / multipler
    }
    
    func round(unit: Double) -> Double {
        let multipler = 1 / unit
        return (self * multipler).rounded() / multipler
    }
}
