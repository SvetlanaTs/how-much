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
    
    @IBOutlet private var firstPersonView: PersonDebtView!
    @IBOutlet private var secondPersonView: PersonDebtView!
    @IBOutlet private var thirdPersonView: PersonDebtView!
    @IBOutlet private var fourthPersonView: PersonDebtView!
    
    @IBOutlet private var leftArrowImageView: UIImageView!
    @IBOutlet private var rightArrowImageView: UIImageView!
    @IBOutlet private var topArrowImageView: UIImageView!
    @IBOutlet private var topDebtLabel: UILabel!
    
    @IBOutlet private var checkButton: UIButton!

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        guard let firstPerson = group.members.first, let fourthPerson = group.members.last else { return }
        let secondPerson = group.members[1]
        let thirdPerson = group.members[2]
        firstPersonView.nameLabel.text = firstPerson.name
        firstPersonView.debtLabel.text = firstPerson.amountSpent.description
        secondPersonView.nameLabel.text = secondPerson.name
        secondPersonView.debtLabel.text = secondPerson.amountSpent.description
        thirdPersonView.nameLabel.text = thirdPerson.name
        thirdPersonView.debtLabel.text = thirdPerson.amountSpent.description
        fourthPersonView.nameLabel.text = fourthPerson.name
        fourthPersonView.debtLabel.text = fourthPerson.amountSpent.description
    }
}
