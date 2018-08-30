//
//  CurrencyConvertService.swift
//  HowMuch
//
//  Created by Svetlana T on 17.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

protocol CurrencyConvertable {
    func convert(amount: Decimal, fromCurrency: Currency, toCurrency: Currency) -> Decimal
}

class CurrencyConvertService: CurrencyConvertable {
    private let rateKey = "Previous"
    private let dollarKey = "USD"
    private let euroKey = "EUR"
    private var currencies: [String: Any]
    private var dollar: Decimal = 0
    private var euro: Decimal = 0
    private let baseRate: Decimal = 1.0

    init(currencies: [String: Any]) {
        self.currencies = currencies
        dollar = dollarRate()
        euro = euroRate()
    }
    
    private func dollarRate() -> Decimal {
        let dollar = currencies.filter { $0.key == dollarKey }
        guard let dollarInfo = dollar[dollarKey] as? [String: Any],
            let rate = dollarInfo[rateKey] as? NSNumber else { return 0 }
        return rate.decimalValue
    }
    
    private func euroRate() -> Decimal {
        let euro = currencies.filter { $0.key == euroKey }
        guard let euroInfo = euro[euroKey] as? [String: Any],
            let rate = euroInfo[rateKey] as? NSNumber else { return 0 }
        return rate.decimalValue
    }

    private func baseRate(_ currency: Currency) -> Decimal {
        switch currency {
        case .dollar:
            return baseRate / dollar
        case .euro:
            return baseRate / euro
        case .ruble:
            return baseRate
        }
    }

    func convert(amount: Decimal, fromCurrency: Currency, toCurrency: Currency) -> Decimal {
        return amount * baseRate(toCurrency) / baseRate(fromCurrency)
    }
}
