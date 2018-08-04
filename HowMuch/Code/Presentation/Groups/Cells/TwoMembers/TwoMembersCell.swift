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
    
    private let duration: TimeInterval = 0.8

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        let debtGroup = DebtDataService.getDebtGroup(group)
        guard let firstPerson = debtGroup.debtors.first, let secondPerson = debtGroup.debtors.last, let arrow = debtGroup.arrows.first else { return }
        
        firstPersonView.nameLabel.text = firstPerson.person.name
        firstPersonView.debtLabel.text = firstPerson.debt.description
        secondPersonView.nameLabel.text = secondPerson.person.name
        secondPersonView.debtLabel.text = secondPerson.debt.description
        UIView.animate(withDuration: duration) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: arrow.angle)
        }
    }
}
