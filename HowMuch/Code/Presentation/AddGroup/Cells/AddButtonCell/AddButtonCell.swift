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
    var addItem: (() -> Void)?
    
    @IBOutlet var addButton: UIButton!
    @IBAction func didSelect(_ sender: UIButton) {
        addItem?()
    }
    
    func set(title: String) {
       update(title: title)
    }
    
    private func update(title: String) {
        addButton.setTitle(title, for: .normal)
    }
}
