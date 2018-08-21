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
    var selectedIndexHandler: ((Int) -> Void)?
    
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    @IBAction private func didSelect(_ sender: UISegmentedControl) {
        selectedIndexHandler?(sender.selectedSegmentIndex)
    }
    
    func set(currencies: [Currency], currentIndex: Int) {
        update(currencies: currencies, currentIndex: currentIndex)
    }
    
    private func update(currencies: [Currency], currentIndex: Int) {
        segmentedControl.removeAllSegments()
        for (index, currency) in currencies.enumerated() {
            segmentedControl.insertSegment(withTitle: currency.rawValue, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = currentIndex
    }
}
