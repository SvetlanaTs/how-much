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
    var editingChanged: ((String?) -> Void)?
    @IBOutlet private var textField: UITextField!
    
    @IBAction private func textFieldEditingChanged(_ sender: UITextField) {
        editingChanged?(sender.text)
    }
    
    func set(text: String, delegate: UITextFieldDelegate) {
        update(text: text, delegate: delegate)
    }
    
    private func update(text: String, delegate: UITextFieldDelegate) {
        textField.text = text
        textField.delegate = delegate
    }
}
