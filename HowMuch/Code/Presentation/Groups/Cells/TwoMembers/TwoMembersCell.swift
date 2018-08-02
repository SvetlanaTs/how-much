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

    func set(group: Group) {
        update(group: group)
    }
    
    private func update(group: Group) {
        guard let firstPerson = group.members.first, let secondPerson = group.members.last else { return }
        firstPersonView.nameLabel.text = firstPerson.name
        firstPersonView.debtLabel.text = firstPerson.amountSpent.description
        secondPersonView.nameLabel.text = secondPerson.name
        secondPersonView.debtLabel.text = secondPerson.amountSpent.description
    }
}
