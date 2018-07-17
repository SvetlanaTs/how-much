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
    private var name = ""
    private var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(NameInputCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
        sections = configureSections()
    }
    
    private func configureSections() -> [[Cell]] {
        let members = dataService.members
        var persons: [Cell] = members.map{ .personEditor(name: $0.name) }
        persons.append(.personEditor(name: ""))
        return [persons, [ .addButton ]]
    }
    
    private func updateModel() {
        guard (0 ..< dataService.members.count).contains(index) else {
            dataService.add(name: name, at: index)
            return
        }
        guard !name.isEmpty else {
            dataService.remove(at: index)
            return
        }
        guard name == dataService.name(at: index) else {
            dataService.rename(name, at: index)
            return
        }
    }
    
    private func reloadTableView() {
        sections = configureSections()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateModel()
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
            cell.editingChanged = { [weak self] text in
                guard let `self` = self, let text = text else { return }
                self.name = text
                self.index = indexPath.row
                self.updateModel()
            }
            return cell
        case .addButton:
            let cell = tableView.dequeueReusableCell(AddButtonCell.id, indexPath: indexPath)
            cell.addNameInput = { [weak self] in
                self?.reloadTableView()
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
