//
//  FourMembersCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class FourMembersCell: BaseMemberCell {
    static let id = Reusable<FourMembersCell>.nib(id: "FourMembersCell", name: "FourMembersCell", bundle: nil)
    
    @IBOutlet var firstPersonView: PersonDebtView!
    @IBOutlet var secondPersonView: PersonDebtView!
    @IBOutlet var thirdPersonView: PersonDebtView!
    @IBOutlet var fourthPersonView: PersonDebtView!
    
    @IBOutlet var leftArrowImageView: UIImageView!
    @IBOutlet var rightArrowImageView: UIImageView!
    @IBOutlet var topArrowImageView: UIImageView!
    @IBOutlet var topDebtLabel: UILabel!
    
    @IBOutlet var checkButton: UIButton!
}
