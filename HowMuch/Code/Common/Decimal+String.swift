//
//  Decimal+String.swift
//  HowMuch
//
//  Created by Svetlana T on 06.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

extension Decimal {
    static let fractionalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        return formatter
    }()
    
    var stringFormatted: String {
        return Decimal.fractionalFormatter.string(for: self) ?? ""
    }
}
