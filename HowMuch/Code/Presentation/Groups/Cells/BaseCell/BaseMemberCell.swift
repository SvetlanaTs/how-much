//
//  BaseMemberCell.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

class BaseMemberCell: UITableViewCell {
    @IBOutlet var backContentView: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backContentView.makeRoundCorners()
        backContentView.applyShadow()
    }
}
