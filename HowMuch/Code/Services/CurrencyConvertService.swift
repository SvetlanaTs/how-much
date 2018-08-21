//
//  CurrencyConvertService.swift
//  HowMuch
//
//  Created by Svetlana T on 17.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class CurrencyConvertService {
    private let rateKey = "Previous"
    private let dollarKey = "USD"
    private let euroKey = "EUR"
    private var currencies: [String: Any]
    private var dollar: Decimal = 0
    private var euro: Decimal = 0
    private var euroToDollar: Decimal = 0
    
    init(currencies: [String: Any]) {
        self.currencies = currencies
        dollar = dollarRate()
        euro = euroRate()
        euroToDollar = euro / dollar
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
    
    func convertToRubles(amountInDollars: Decimal) -> Decimal {
        return amountInDollars * dollar
    }
    
    func convertToRubles(amountInEuros: Decimal) -> Decimal {
        return amountInEuros * euro
    }
    
    func convertToEuros(amountInRubles: Decimal) -> Decimal {
        return (euro == 0) ? 0 : amountInRubles / euro
    }
    
    func convertToDollars(amountInRubles: Decimal) -> Decimal {
        return (dollar == 0) ? 0 : amountInRubles / dollar
    }
    
    func convertToEuros(amountInDollars: Decimal) -> Decimal {
        return (euroToDollar == 0) ? 0 : amountInDollars / euroToDollar
    }

    func convertToDollars(amountInEuros: Decimal) -> Decimal {
        return amountInEuros * euroToDollar
    }
}
