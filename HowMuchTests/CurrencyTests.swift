//
//  CurrencyTests.swift
//  HowMuchTests
//
//  Created by Svetlana T on 22.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import XCTest
@testable import HowMuch

class CurrencyTests: XCTestCase {
    func testCurrencyConversion() {
        let amounts: [Decimal] = [
            200,
            175,
            344.3,
            2000,
            5432.7,
            12
        ]
        let networkService = NetworkService()
        let currencyService = CurrencyService(networkService: networkService)
        currencyService.loadCurrencies { currencies in
            let currencyConvertService = CurrencyConvertService(currencies: currencies)
            amounts.forEach { amount in
                let dollarAmount = currencyConvertService.convert(amount: amount, fromCurrency: .euro, toCurrency: .dollar)
                let euroAmount = currencyConvertService.convert(amount: dollarAmount, fromCurrency: .dollar, toCurrency: .euro)
                XCTAssertEqual(dollarAmount, euroAmount)
            }
        }
    }
}
