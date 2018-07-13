//
//  AddGroupViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

enum Cell {
    case personEditor(name: String)
    case addButton
}

struct AddGroupConstants {
    static let textFieldCellHeight: CGFloat = 64.0
    static let addButtonCellHeight: CGFloat = 56.0
    static let membersMinValue = 2
    static let membersMaxValue = 4
}

final class AddGroupViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private var sections: [[Cell]] = [[ .personEditor(name: "") ], [ .addButton ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(NameInputCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
    }

    @IBAction func createGroup(_ sender: UIButton) {
        guard var members = sections.first else { return }
        if case .personEditor(let name) = members[0], name == "" {
            members.remove(at: 0)
        }
        print(members)
        // TODO: segue
    }
}

extension AddGroupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section][indexPath.row]
        switch model {
        case .personEditor(_):
            let cell = tableView.dequeueReusableCell(NameInputCell.id, indexPath: indexPath)
            cell.textField.delegate = self
            return cell
        case .addButton:
            let cell = tableView.dequeueReusableCell(AddButtonCell.id, indexPath: indexPath)
            cell.addNameInput = { [weak self] in
                self?.tableView.reloadData()
            }
            return cell
        }
    }
}

extension AddGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = sections[indexPath.section][indexPath.row]
        switch model {
        case .personEditor(_):
            return AddGroupConstants.textFieldCellHeight
        case .addButton:
            return AddGroupConstants.addButtonCellHeight
        }
    }
}

extension AddGroupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
            !text.isEmpty else { return }
        sections[0].append(.personEditor(name: text))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
