//
//  PurchaseSectionHeaderView.swift
//  HowMuch
//
//  Created by Svetlana T on 26.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class PurchaseSectionHeaderView: UITableViewHeaderFooterView {
    static let id = Reusable<PurchaseSectionHeaderView>.nib(id: "PurchaseSectionHeaderView", name: "PurchaseSectionHeaderView", bundle: nil)
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var amountSpentLabel: UILabel!

    func set(name: String, amountSpent: Decimal) {
        nameLabel.text = name
        amountSpentLabel.text = amountSpent.description
    }
}
