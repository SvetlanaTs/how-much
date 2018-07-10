//
//  Person.swift
//  HowMuch
//
//  Created by Svetlana T on 10.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class Person {
    
    let name: String
    var purchases: [Purchase]?
    var amountSpent: Double {
        guard let purchases = purchases else { return 0.0 }
        return purchases.map{ $0.price }.reduce(0.0, +)
    }
    
    init(name: String) {
        self.name = name
    }
}
