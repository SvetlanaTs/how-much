//
//  AddButtonCell.swift
//  HowMuch
//
//  Created by Svetlana T on 11.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class AddButtonCell: UITableViewCell {
    static let id = Reusable<AddButtonCell>.nib(id: "AddButtonCell", name: "AddButtonCell", bundle: nil)
    var addItemHandler: (() -> Void)?
    
    @IBAction func didSelect(_ sender: UIButton) {
        addItemHandler?()
    }
}
