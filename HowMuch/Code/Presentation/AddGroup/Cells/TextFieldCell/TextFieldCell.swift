//
//  TextFieldCell.swift
//  HowMuch
//
//  Created by Svetlana T on 11.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class TextFieldCell: UITableViewCell {
    static let id = Reusable<TextFieldCell>.nib(id: "TextFieldCell", name: "TextFieldCell", bundle: nil)
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.becomeFirstResponder()
    }
}
