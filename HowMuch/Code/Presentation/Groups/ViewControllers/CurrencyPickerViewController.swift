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
        case title(title: String)
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
        let currencies: Set<String> = Set(Currency.allCases.map { $0.code })
        let current: Set<String> = [currentCurrency.code]
        let availableCurrencies: Set<String> = currencies.subtracting(current)
        availableCurrencies.forEach { rows.append(.title(title: $0)) }
    }

    @IBAction private func didTap(_ sender: UIView) {
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
        case .title(let title):
            return title
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dismiss(animated: true) {
            let model = self.rows[row]
            switch model {
            case .title(let title):
                guard let currency = Currency(code: title) else { return }
                self.updateCurrencyHandler?(currency)
            }
        }
    }
}
