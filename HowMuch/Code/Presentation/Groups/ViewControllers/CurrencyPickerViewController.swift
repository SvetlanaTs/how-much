//
//  CurrencyPickerViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 27.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class CurrencyPickerViewController: UIViewController {
    enum Row {
        case currency(currency: Currency)
    }

    private let numberOfComponents = 1
    private var rows: [Row] = []
    var currentCurrency: Currency!
    var updateCurrencyHandler: ((Currency) -> Void)?
    @IBOutlet private var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateRows()
    }

    private func updateRows() {
        let currencies = Currency.allCases.filter { $0 != currentCurrency }
        currencies.forEach { rows.append(.currency(currency: $0)) }
    }

    @IBAction private func didTap() {
        dismiss(animated: true, completion: nil)
    }
}

extension CurrencyPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rows.count
    }
}

extension CurrencyPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = rows[row]
        switch model {
        case .currency(let currency):
            return currency.code
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dismiss(animated: true) {
            let model = self.rows[row]
            switch model {
            case .currency(let currency):
                self.updateCurrencyHandler?(currency)
            }
        }
    }
}
