//
//  TextFieldCell.swift
//  HowMuch
//
//  Created by Svetlana T on 11.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class TextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    static let reuseIdentifier = "text-field"
}
