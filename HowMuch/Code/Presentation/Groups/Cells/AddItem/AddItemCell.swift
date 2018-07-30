//
//  AddItemCell.swift
//  HowMuch
//
//  Created by Svetlana T on 25.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class AddItemCell: UITableViewCell {
    static let id = Reusable<AddItemCell>.nib(id: "AddItemCell", name: "AddItemCell", bundle: nil)
    var addItemHandler: (() -> Void)?
    
    @IBAction private func didSelect(_ sender: UIButton) {
        addItemHandler?()
    }
}
