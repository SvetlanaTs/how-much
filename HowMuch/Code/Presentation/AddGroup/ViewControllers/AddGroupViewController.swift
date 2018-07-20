//
//  AddGroupViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class AddGroupViewController: UIViewController {
    enum AddGroupCell {
        case personEditor(name: String)
        case addButton
    }
    
    struct AddGroupConstants {
        static let textFieldCellHeight: CGFloat = 64.0
        static let addButtonCellHeight: CGFloat = 56.0
        static let membersMinValue = 2
        static let membersMaxValue = 4
        static let segueIdentifier = "showGroup"
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private var dataService: DataService = DataService()
    private var sections: [[AddGroupCell]] = []
    private var name = ""
    private var index = -1
    private var needToUpdate: Bool = false
    private var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        tableView.registerReusableCell(NameInputCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
        sections = formSections()
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    private func formSections() -> [[AddGroupCell]] {
        let members = dataService.members
        var persons: [AddGroupCell] = members.map{ .personEditor(name: $0.name) }
        persons.append(.personEditor(name: ""))
        return [persons, [ .addButton ]]
    }
    
    private func updateModel() {
        guard (0 ..< dataService.members.count).contains(index) else {
            dataService.add(name: name, at: index)
            needToUpdate = true
            return
        }
        guard !name.isEmpty else {
            dataService.remove(at: index)
            needToUpdate = true
            return
        }
        guard name == dataService.name(at: index) else {
            dataService.rename(name, at: index)
            needToUpdate = true
            return
        }
    }
    
    private func reloadTableView() {
        sections = formSections()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        createGroup()
        
        guard let destination = segue.destination as? UINavigationController,
            let target = destination.topViewController as? GroupListViewController else { return }
        target.dataService = dataService
    }
    
    private func createGroup() {
        let group = Group(members: dataService.members)
        dataService.add(group: group)
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
                guard let `self` = self else { return }
                if self.needToUpdate {
                    self.reloadTableView()
                    self.needToUpdate = false
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if self.needToUpdate {
            self.reloadTableView()
            self.needToUpdate = false
        }
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
