//
//  GroupCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class GroupCell: UITableViewCell {
    static let id = Reusable<GroupCell>.nib(id: "GroupCell", name: "GroupCell", bundle: nil)
    
    @IBOutlet private var resultLabel: UILabel!

    func set(group: Group, payments: [Payment]) {
        update(group: group, payments: payments)
    }
    
    private func update(group: Group, payments: [Payment]) {
        resultLabel.text = ""
        
        if payments.isEmpty {
            resultLabel.text = group.members
                .map { $0.name }
                .joined(separator: " ")
            return
        }
        
        payments.forEach { payment in
            let debtor = group.members[payment.payerId]
            let creditor = group.members[payment.id]
            let debt = payment.debt
            let currency = group.currency
            resultLabel.text? += result(debtor: debtor, creditor: creditor, debt: debt, currency: currency)
        }
    }
    
    private func result(debtor: Person, creditor: Person, debt: Decimal, currency: Currency) -> String {
        let debtString = debt.stringFormatted
        let debtCurrencyString: String = (currency == .ruble) ? debtString + currency.rawValue : currency.rawValue + debtString
        return "\(debtor.name) got to give \(debtCurrencyString) to \(creditor.name)\n"
    }
}
