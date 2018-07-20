//
//  ThreeMembersCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class ThreeMembersCell: BaseMemberCell {
    static let id = Reusable<ThreeMembersCell>.nib(id: "ThreeMembersCell", name: "ThreeMembersCell", bundle: nil)
    
    @IBOutlet var firstPersonView: PersonDebtView!
    @IBOutlet var secondPersonView: PersonDebtView!
    @IBOutlet var thirdPersonView: PersonDebtView!
    
    @IBOutlet var leftArrowImageView: UIImageView!
    @IBOutlet var rightArrowImageView: UIImageView!
    @IBOutlet var checkButton: UIButton!
}
