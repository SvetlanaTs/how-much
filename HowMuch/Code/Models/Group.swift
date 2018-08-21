//
//  Group.swift
//  HowMuch
//
//  Created by Svetlana T on 10.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

enum Currency: CaseIterable {
    case euro
    case ruble
    case dollar

    var symbol: String {
        switch self {
        case .dollar:
            return "$"
        case .ruble:
            return "₽"
        case .euro:
            return "€"
        }
    }

    var code: String {
        switch self {
        case .dollar:
            return "USD"
        case .ruble:
            return "RUB"
        case .euro:
            return "EUR"
        }
    }

    var index: Int {
        switch self {
        case .ruble:
            return 0
        case .dollar:
            return 1
        case .euro:
            return 2
        }
    }

    init?(index: Int) {
        switch index {
        case 0:
            self = .ruble
        case 1:
            self = .dollar
        case 2:
            self = .euro
        default:
            return nil
        }
    }
}

extension Currency: Comparable {
    static func ==(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.index == rhs.index
    }
    
    static func <(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.index < rhs.index
    }
}

extension Currency: Codable {
    enum Key: CodingKey {
        case rawValue
    }

    enum CodingError: Error {
        case unknownValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .ruble
        case 1:
            self = .dollar
        case 2:
            self = .euro
        default:
            throw CodingError.unknownValue
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .ruble:
            try container.encode(0, forKey: .rawValue)
        case .dollar:
            try container.encode(1, forKey: .rawValue)
        case .euro:
            try container.encode(2, forKey: .rawValue)
        }
    }
}

struct Group: Codable {
    let members: [Person]
    let currency: Currency
}
