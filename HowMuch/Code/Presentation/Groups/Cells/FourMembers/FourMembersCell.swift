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
        let debtGroup = debtService.debtGroup()
        var debtors: [Person] = []
        var creditors: [Person] = []
        resultLabel.text = ""
        
        debtGroup.members.forEach { person in
            person.debt > 0.0 ? debtors.append(person) : creditors.append(person)
        }
        
        if debtors.isEmpty {
            creditors.forEach { resultLabel.text? += "\($0.name) " }
        } else if debtors.count == creditors.count {
            if debtors[0].debt + creditors[0].debt == 0.0 {
                resultLabel.text? += result(debtor: debtors[0], creditor: creditors[0])
                resultLabel.text? += result(debtor: debtors[1], creditor: creditors[1])
            } else if debtors[0].debt + creditors[1].debt == 0.0 {
                resultLabel.text? += result(debtor: debtors[0], creditor: creditors[1])
                resultLabel.text? += result(debtor: debtors[1], creditor: creditors[0])
            } else {
                let minDebtor = (debtors[0].debt < debtors[1].debt) ? debtors[0] : debtors[1]
                let maxDebtor = (debtors[0].debt > debtors[1].debt) ? debtors[0] : debtors[1]
                let minCreditor = (abs(creditors[0].debt) < abs(creditors[1].debt)) ? creditors[0] : creditors[1]
                let maxCreditor = (abs(creditors[0].debt) > abs(creditors[1].debt)) ? creditors[0] : creditors[1]
                let minDebtForMaxCreditor = minDebtor.debt - abs(minCreditor.debt)

                resultLabel.text? += result(debtor: maxDebtor, creditor: maxCreditor)
                resultLabel.text? += result(debtor: minDebtor, creditor: minCreditor, debt: minCreditor.debt)
                resultLabel.text? += result(debtor: minDebtor, creditor: maxCreditor, debt: minDebtForMaxCreditor)
            }
        } else {
            if debtors.count == onePerson {
                resultLabel.text? += result(debtor: debtors[0], creditor: creditors[0])
                resultLabel.text? += result(debtor: debtors[0], creditor: creditors[1])
                resultLabel.text? += result(debtor: debtors[0], creditor: creditors[2])
            } else if creditors.count == onePerson {
                resultLabel.text? += result(debtor: debtors[0], creditor: creditors[0])
                resultLabel.text? += result(debtor: debtors[1], creditor: creditors[0])
                resultLabel.text? += result(debtor: debtors[2], creditor: creditors[0])
            }
        }
    }
    
    private func result(debtor: Person, creditor: Person) -> String {
        let debt = debtor.debt
        return result(debtor: debtor, creditor: creditor, debt: debt)
    }
    
    private func result(debtor: Person, creditor: Person, debt: Decimal) -> String {
        let debtString = TypeConvertor.stringFromDecimal(abs(debt))
        return "\(debtor.name) got to give $\(debtString) to \(creditor.name)\n"
    }
}
