//
//  Decimal+String.swift
//  HowMuch
//
//  Created by Svetlana T on 06.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

extension Locale {
    static let ru = Locale(identifier: "ru_RU")
    static let eu = Locale(identifier: "en_EU")
    static let us = Locale(identifier: "en_US")
}

extension Decimal {
    static let fractionalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        formatter.numberStyle = .currency
        return formatter
    }()

    func stringFormatted(by currency: Currency) -> String {
        switch currency {
        case .ruble:
            Decimal.fractionalFormatter.locale = .ru
        case .euro:
            Decimal.fractionalFormatter.locale = .eu
        case .dollar:
            Decimal.fractionalFormatter.locale = .us
        }
        return Decimal.fractionalFormatter.string(for: self) ?? ""
    }
}
