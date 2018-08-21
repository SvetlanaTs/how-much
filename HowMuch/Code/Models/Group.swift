//
//  Group.swift
//  HowMuch
//
//  Created by Svetlana T on 10.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

enum Currency: String, Codable, CaseIterable {
    case ruble = "₽"
    case dollar = "$"
    case euro = "€"
}

struct Group: Codable {
    let members: [Person]
    let currency: Currency
}
