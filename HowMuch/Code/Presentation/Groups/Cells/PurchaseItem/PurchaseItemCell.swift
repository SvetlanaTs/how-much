//
//  PurchaseItemCell.swift
//  HowMuch
//
//  Created by Svetlana T on 24.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class PurchaseItemCell: UITableViewCell {
    static let id = Reusable<PurchaseItemCell>.nib(id: "PurchaseItemCell", name: "PurchaseItemCell", bundle: nil)
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var spentLabel: UILabel!
    
    func set(purchase: Purchase, currency: Currency) {
        update(purchase: purchase, currency: currency)
    }
    
    private func update(purchase: Purchase, currency: Currency) {
        titleLabel.text = purchase.title
        spentLabel.text = purchase.spent.stringFormatted(by: currency)
    }
}
