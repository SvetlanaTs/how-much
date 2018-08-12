//
//  FourMembersCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class FourMembersCell: UITableViewCell {
    static let id = Reusable<FourMembersCell>.nib(id: "FourMembersCell", name: "FourMembersCell", bundle: nil)
    
    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var checkButton: UIButton!
    
    private let onePerson = 1

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        let debtService = DebtDataService(group: group)
        let payments = debtService.payments()
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
            resultLabel.text? += result(debtor: debtor, creditor: creditor, debt: debt)
        }
    }
    
    private func result(debtor: Person, creditor: Person, debt: Decimal) -> String {
        let debtString = debt.stringFormatted
        return "\(debtor.name) got to give $\(debtString) to \(creditor.name)\n"
    }
}
