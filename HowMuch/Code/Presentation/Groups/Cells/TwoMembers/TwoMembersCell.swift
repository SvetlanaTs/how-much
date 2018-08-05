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
    
    private let noDebtString = "0.0"
    private let rotationAngle: CGFloat = .pi / 2

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        let debtService = DebtDataService(group: group)
        let debtGroup = debtService.debtGroup()
        guard let firstPerson = debtGroup.members.first, let secondPerson = debtGroup.members.last else { return }
        
        firstPersonView.nameLabel.text = firstPerson.name
        firstPersonView.debtLabel.text = (firstPerson.debt < 0.0) ? noDebtString : firstPerson.debt.description
        secondPersonView.nameLabel.text = secondPerson.name
        secondPersonView.debtLabel.text = (secondPerson.debt < 0.0) ? noDebtString : secondPerson.debt.description
        UIView.animate(withDuration: Style.Duration.arrow) {
            let angle: CGFloat = (firstPerson.debt > 0.0) ? self.rotationAngle : -self.rotationAngle
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
