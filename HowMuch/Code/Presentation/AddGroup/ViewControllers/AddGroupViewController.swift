//
//  AddGroupViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class AddGroupViewController: UIViewController {
    enum Cell {
        case personEditor(name: String)
        case addButton
    }
    
    struct AddGroupConstants {
        static let textFieldCellHeight: CGFloat = 64.0
        static let addButtonCellHeight: CGFloat = 56.0
        static let membersMinValue = 2
        static let membersMaxValue = 4
        static let segueIdentifier = "show-group"
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private var dataService = DataService()
    private var sections: [[Cell]] = []
    private var hasChanges: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(NameInputCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
        updateSections()
    }
    
    private func updateSections() {
        let members = dataService.members
        var persons: [Cell] = members.map{ .personEditor(name: $0.name) }
        persons.append(.personEditor(name: ""))
        sections = [persons, [ .addButton ]]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AddGroupConstants.segueIdentifier {
            guard let vc = segue.destination as? GroupListViewController else { return }
            vc.groups = dataService.members.map { Group(members: [$0]) }
        }
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
        case .personEditor(let name):
            let cell = tableView.dequeueReusableCell(NameInputCell.id, indexPath: indexPath)
            cell.textField.delegate = self
            cell.textField.text = name
            cell.textField.tag = indexPath.row
            return cell
        case .addButton:
            let cell = tableView.dequeueReusableCell(AddButtonCell.id, indexPath: indexPath)
            cell.addNameInput = { [weak self] in
                guard let this = self else { return }
                if this.hasChanges {
                    this.updateSections()
                    this.tableView.reloadData()
                }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NameInputCell {
            cell.textField.becomeFirstResponder()
        }
    }
}

extension AddGroupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let index = textField.tag
        textField.resignFirstResponder()
        
        if dataService.members.count > index {
            // edit an existing member
            if text.isEmpty {
                dataService.remove(at: index)
            }
            if text != dataService.name(at: index) {
                dataService.rename(text, at: index)
            }
            hasChanges = text.isEmpty || text != dataService.name(at: index)
        } else {
            if !text.isEmpty {
                dataService.add(name: text, at: index)
            }
            hasChanges = !text.isEmpty
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
