//
//  CurrencyControlCell.swift
//  HowMuch
//
//  Created by Svetlana T on 16.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class CurrencyControlCell: UITableViewCell {
    static let id = Reusable<CurrencyControlCell>.nib(id: "CurrencyControlCell", name: "CurrencyControlCell", bundle: nil)
    var currencyHandler: ((Currency) -> Void)?
    
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    @IBAction private func didSelect(_ sender: UISegmentedControl) {
        guard let currency = Currency(index: sender.selectedSegmentIndex) else { return }
        currencyHandler?(currency)
    }
    
    func set(currencies: [Currency], currentCurrency: Currency) {
        update(currencies: currencies, currentCurrency: currentCurrency)
    }
    
    private func update(currencies: [Currency], currentCurrency: Currency) {
        segmentedControl.removeAllSegments()
        for (index, currency) in currencies.sorted().enumerated() {
            segmentedControl.insertSegment(withTitle: currency.code, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = currentCurrency.index
    }
}
