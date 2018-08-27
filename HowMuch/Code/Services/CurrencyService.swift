//
//  CurrencyService.swift
//  HowMuch
//
//  Created by Svetlana T on 17.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class CurrencyService {
    typealias CurrencyHandler = (([String: Any]) -> Void)
    private let currencyKey = "Valute"
    private let cachedKey: NSString = "currencies"
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func loadCurrencies(completion: CurrencyHandler?) {
        if let currencies = CacheService.shared.object(forKey: cachedKey) as? [String: Any] {
            completion?(currencies)
        } else {
            networkService.currencyExchangeRate { json in
                guard let dict = json as? [String: Any],
                    let currencies = dict[self.currencyKey] as? [String: Any] else { return }
                CacheService.shared.saveObject(currencies as AnyObject, forKey: self.cachedKey)
                completion?(currencies)
            }
        }
    }
}
