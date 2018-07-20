//
//  TwoMembersCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class TwoMembersCell: BaseMemberCell {
    static let id = Reusable<TwoMembersCell>.nib(id: "TwoMembersCell", name: "TwoMembersCell", bundle: nil)
    
    @IBOutlet var firstPersonView: PersonDebtView!
    @IBOutlet var secondPersonView: PersonDebtView!
    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var checkButton: UIButton!
}
