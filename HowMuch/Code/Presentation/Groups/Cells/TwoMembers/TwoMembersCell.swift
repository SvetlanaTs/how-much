//
//  TwoMembersCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class TwoMembersCell: UITableViewCell {
    static let id = Reusable<TwoMembersCell>.nib(id: "TwoMembersCell", name: "TwoMembersCell", bundle: nil)
    
    @IBOutlet private var firstPersonView: PersonDebtView!
    @IBOutlet private var secondPersonView: PersonDebtView!
    @IBOutlet private var arrowImageView: UIImageView!
    @IBOutlet private var checkButton: UIButton!
    
    private let rotationAngle: CGFloat = .pi / 2

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        let debtService = DebtDataService(group: group)
        let payments = debtService.payments()
        let members = group.members
        let views = Dictionary(uniqueKeysWithValues: zip(0...Int.max, [firstPersonView, secondPersonView]))
        
        if payments.isEmpty {
            let names: [String] = members.map { $0.name }
            views.forEach { viewDict in
                guard let view = viewDict.value else { return }
                view.nameLabel.text = names[viewDict.key]
                view.debtLabel.text = "0"
            }
            return
        }

        guard let payment = payments.first else { return }
        firstPersonView.nameLabel.text = members[payment.payerId].name
        firstPersonView.debtLabel.text = payment.debt.stringFormatted
        secondPersonView.nameLabel.text = members[payment.id].name
        secondPersonView.debtLabel.text = "0"
        UIView.animate(withDuration: Style.Duration.arrow) {
            let angle: CGFloat = self.rotationAngle
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
