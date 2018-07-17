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
    private var needToUpdate: Bool = false
    private var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        tableView.registerReusableCell(NameInputCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
        sections = configureSections()
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    private func configureSections() -> [[Cell]] {
        let members = dataService.members
        var persons: [Cell] = members.map{ .personEditor(name: $0.name) }
        persons.append(.personEditor(name: ""))
        return [persons, [ .addButton ]]
    }
    
    private func updateModel() {
        needToUpdate = false
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
        if needToUpdate { updateModel() }
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
                self.needToUpdate = true
            }
            return cell
        case .addButton:
            let cell = tableView.dequeueReusableCell(AddButtonCell.id, indexPath: indexPath)
            cell.addNameInput = { [weak self] in
                guard let `self` = self else { return }
                if self.needToUpdate {
                    self.updateModel()
                    self.reloadTableView()
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
}

extension AddGroupViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        activeField = nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddGroupViewController {
    @objc func keyboardWasShown(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height

        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
        tableView.contentInset = contentInsets

        var activeRect: CGRect = view.frame
        activeRect.size.height -= keyboardHeight

        guard let activeField = activeField else { return }
        if !activeRect.contains(activeField.frame.origin) {
            tableView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }

    @objc func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets: UIEdgeInsets = .zero
        tableView.contentInset = contentInsets
    }
}
