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
    
    private let rotationAngle: CGFloat = .pi / 2
    private let oneDebtor = 1
    private let decimalPlaces = 2

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        let debtService = DebtDataService(group: group)
        let debtGroup = debtService.debtGroup()
        var debtors: [Person] = []
        var creditors: [Person] = []
        
        debtGroup.members.forEach { person in
            person.debt > 0.0 ? debtors.append(person) : creditors.append(person)
        }
        
        guard let firstPerson = (debtors.count == oneDebtor) ? creditors.first : debtors.first,
            let secondPerson = (debtors.count == oneDebtor) ? debtors.first : creditors.first,
            let thirdPerson = (debtors.count == oneDebtor) ? creditors.last : debtors.last else { return }
        
        firstPersonView.nameLabel.text = firstPerson.name
        firstPersonView.debtLabel.text = stringFromDecimal(abs(firstPerson.debt))
        secondPersonView.nameLabel.text = secondPerson.name
        secondPersonView.debtLabel.text = stringFromDecimal(abs(secondPerson.debt))
        thirdPersonView.nameLabel.text = thirdPerson.name
        thirdPersonView.debtLabel.text = stringFromDecimal(abs(thirdPerson.debt))
        UIView.animate(withDuration: Style.Duration.arrow) {
            let leftArrow: CGFloat = (firstPerson.debt > 0.0) ? self.rotationAngle : -self.rotationAngle
            let rightArrow: CGFloat = (thirdPerson.debt > 0.0) ? -self.rotationAngle : self.rotationAngle
            self.leftArrowImageView.transform = CGAffineTransform(rotationAngle: leftArrow)
            self.rightArrowImageView.transform = CGAffineTransform(rotationAngle: rightArrow)
        }
    }
    
    private func stringFromDecimal(_ value: Decimal) -> String {
        var decimal = value
        var roundedDecimal: Decimal = Decimal()
        NSDecimalRound(&roundedDecimal, &decimal, decimalPlaces, .plain)
        return roundedDecimal.description
    }
}
