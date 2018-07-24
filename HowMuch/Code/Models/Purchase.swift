//
//  Purchase.swift
//  HowMuch
//
//  Created by Svetlana T on 10.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

struct Purchase: Codable {
    let title: String
    let spent: Decimal
    let date: Date
}
