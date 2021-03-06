//
//  Person.swift
//  HowMuch
//
//  Created by Svetlana T on 10.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

struct Person: Codable {
    let name: String
    var purchases: [Purchase] = []
    var debt: Decimal
    var amountSpent: Decimal {
        return purchases.reduce(Decimal(0)) { $0 + $1.spent }
    }
}
