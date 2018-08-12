//
//  ThreeMembersCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class ThreeMembersCell: UITableViewCell {
    typealias Debtor = (name: String, debt: Decimal)
    static let id = Reusable<ThreeMembersCell>.nib(id: "ThreeMembersCell", name: "ThreeMembersCell", bundle: nil)
    
    @IBOutlet private var firstPersonView: PersonDebtView!
    @IBOutlet private var secondPersonView: PersonDebtView!
    @IBOutlet private var thirdPersonView: PersonDebtView!
    
    @IBOutlet private var leftArrowImageView: UIImageView!
    @IBOutlet private var rightArrowImageView: UIImageView!
    @IBOutlet private var checkButton: UIButton!
    
    private let rotationAngle: CGFloat = .pi / 2

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        let debtService = DebtDataService(group: group)
        let payments = debtService.payments()
        let members = group.members
        let views = Dictionary(uniqueKeysWithValues: zip(0...Int.max, [firstPersonView, secondPersonView, thirdPersonView]))
        
        if payments.isEmpty {
            let names: [String] = members.map { $0.name }
            views.forEach { viewDict in
                guard let view = viewDict.value else { return }
                view.nameLabel.text = names[viewDict.key]
                view.debtLabel.text = "0.00"
            }
            return
        }
        
        var debtors: [Debtor] = []
        var isOneDebtor: Bool
        if payments.count == 1 {
            isOneDebtor = true
            debtors.append((name: members[payments[0].id].name, debt: payments[0].debt))
            debtors.append((name: members[payments[0].payerId].name, debt: payments[0].debt))
            
            var memberNames = Set(members.map { $0.name })
            let debtorNames = Set(debtors.map { $0.name })
            memberNames.subtract(debtorNames)
            for name in memberNames {
                debtors.append((name: name, debt: 0))
            }
        } else {
            isOneDebtor = (payments[0].payerId == payments[1].payerId)
            let totalDebt = payments[0].debt + payments[1].debt
            let firstDebt = isOneDebtor ?
                (name: members[payments[0].id].name, debt: payments[0].debt) :
                (name: members[payments[0].payerId].name, debt: payments[0].debt)
            let secondDebt = isOneDebtor ?
                (name: members[payments[0].payerId].name, debt: totalDebt) :
                (name: members[payments[0].id].name, debt: totalDebt)
            let thirdDebt = isOneDebtor ?
                (name: members[payments[1].id].name, debt: payments[1].debt) :
                (name: members[payments[1].payerId].name, debt: payments[1].debt)
            
            debtors.append(firstDebt)
            debtors.append(secondDebt)
            debtors.append(thirdDebt)
        }
        
        views.forEach { viewDict in
            guard let view = viewDict.value else { return }
            view.nameLabel.text = debtors[viewDict.key].name
            view.debtLabel.text = debtors[viewDict.key].debt.stringFormatted
        }

        UIView.animate(withDuration: Style.Duration.arrow) {
            let leftArrow: CGFloat = isOneDebtor ? -self.rotationAngle : self.rotationAngle
            let rightArrow: CGFloat = isOneDebtor ? self.rotationAngle : -self.rotationAngle
            self.leftArrowImageView.transform = CGAffineTransform(rotationAngle: leftArrow)
            self.rightArrowImageView.transform = CGAffineTransform(rotationAngle: rightArrow)
        }
    }
}
