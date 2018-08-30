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
            65300,
            175,
            344.3,
            2000,
            5432.7,
            120.4
        ]
        let networkService = CBRNetworkService()
        let currencyService = CurrencyService(networkService: networkService)

        let expectation = self.expectation(description: "loadCurrencies")
        var rubleAmounts: [Decimal] = []

        currencyService.loadCurrencies { currencies in
            let currencyConvertService = CurrencyConvertService(currencies: currencies)
            amounts.forEach { amount in
                let dollarAmount = currencyConvertService.convert(amount: amount, fromCurrency: .ruble, toCurrency: .dollar)
                let euroAmount = currencyConvertService.convert(amount: dollarAmount, fromCurrency: .dollar, toCurrency: .euro)
                let rubleAmount = currencyConvertService.convert(amount: euroAmount, fromCurrency: .euro, toCurrency: .ruble)
                rubleAmounts.append(rubleAmount)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(amounts, rubleAmounts)
    }
}
