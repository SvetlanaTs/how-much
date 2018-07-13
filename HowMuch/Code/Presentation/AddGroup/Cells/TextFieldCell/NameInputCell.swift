//
//  NameInputCell.swift
//  HowMuch
//
//  Created by Svetlana T on 11.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class NameInputCell: UITableViewCell {
    static let id = Reusable<NameInputCell>.nib(id: "NameInputCell", name: "NameInputCell", bundle: nil)
    @IBOutlet var textField: UITextField!
}
