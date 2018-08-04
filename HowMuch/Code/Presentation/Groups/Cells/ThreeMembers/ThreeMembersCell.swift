//
//  ThreeMembersCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class ThreeMembersCell: UITableViewCell {
    static let id = Reusable<ThreeMembersCell>.nib(id: "ThreeMembersCell", name: "ThreeMembersCell", bundle: nil)
    
    @IBOutlet private var firstPersonView: PersonDebtView!
    @IBOutlet private var secondPersonView: PersonDebtView!
    @IBOutlet private var thirdPersonView: PersonDebtView!
    
    @IBOutlet private var leftArrowImageView: UIImageView!
    @IBOutlet private var rightArrowImageView: UIImageView!
    @IBOutlet private var checkButton: UIButton!
    
    private let duration: TimeInterval = 0.8

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        let debtGroup = DebtDataService.getDebtGroup(group)
        guard let firstPerson = debtGroup.debtors.first, let thirdPerson = debtGroup.debtors.last,
            let leftArrow = debtGroup.arrows.first, let rightArrow = debtGroup.arrows.last else { return }
        let secondPerson = debtGroup.debtors[1]
        
        firstPersonView.nameLabel.text = firstPerson.person.name
        firstPersonView.debtLabel.text = stringFromDecimal(firstPerson.debt)
        secondPersonView.nameLabel.text = secondPerson.person.name
        secondPersonView.debtLabel.text = stringFromDecimal(secondPerson.debt)
        thirdPersonView.nameLabel.text = thirdPerson.person.name
        thirdPersonView.debtLabel.text = stringFromDecimal(thirdPerson.debt)
        UIView.animate(withDuration: duration) {
            self.leftArrowImageView.transform = CGAffineTransform(rotationAngle: leftArrow.angle)
            self.rightArrowImageView.transform = CGAffineTransform(rotationAngle: rightArrow.angle)
        }
    }
    
    private func stringFromDecimal(_ value: Decimal) -> String {
        var decimal = value
        var roundedDecimal: Decimal = Decimal()
        NSDecimalRound(&roundedDecimal, &decimal, 2, .plain)
        return roundedDecimal.description
    }
}
