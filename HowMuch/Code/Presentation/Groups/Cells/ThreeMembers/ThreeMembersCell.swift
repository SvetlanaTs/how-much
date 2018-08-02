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

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        guard let firstPerson = group.members.first, let thirdPerson = group.members.last else { return }
        let secondPerson = group.members[1]
        firstPersonView.nameLabel.text = firstPerson.name
        firstPersonView.debtLabel.text = firstPerson.amountSpent.description
        secondPersonView.nameLabel.text = secondPerson.name
        secondPersonView.debtLabel.text = secondPerson.amountSpent.description
        thirdPersonView.nameLabel.text = thirdPerson.name
        thirdPersonView.debtLabel.text = thirdPerson.amountSpent.description
    }
}
