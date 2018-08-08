//
//  TypeConvertor.swift
//  HowMuch
//
//  Created by Svetlana T on 06.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class TypeConvertor {
    static private let decimalPlaces = 2
    
    static func stringFromDecimal(_ value: Decimal) -> String {
        var decimal = value
        var roundedDecimal: Decimal = Decimal()
        NSDecimalRound(&roundedDecimal, &decimal, decimalPlaces, .plain)
        return roundedDecimal.description
    }
}
