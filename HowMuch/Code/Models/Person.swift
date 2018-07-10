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
    var purchases: [Purchase] = []
    var amountSpent: Double {
        return purchases.reduce(Double(0)) { $0 + $1.price } 
    }
    
    init(name: String) {
        self.name = name
    }
}
