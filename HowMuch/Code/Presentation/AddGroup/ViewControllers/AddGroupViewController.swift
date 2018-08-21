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
        case currency
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private let membersMinValue = 2
    private let membersMaxValue = 4
    private let segueIdentifier = "showGroup"
    
    private var sections: [[Cell]] = []
    private var name = ""
    private var nameIndex = -1
    private var currencyIndex = 0
    private var needToUpdate: Bool = false
    private var activeField: UITextField?
    private var personDataService: PersonDataService = PersonDataService()
    
    var dataService: DataService!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        tableView.registerReusableCell(NameInputCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
        tableView.registerReusableCell(CurrencyControlCell.id)
        sections = updateSections()
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func updateSections() -> [[Cell]] {
        let members = personDataService.members
        var persons: [Cell] = members.map { .personEditor(name: $0.name) }
        persons.append(.personEditor(name: ""))
        return [persons, [ .addButton ], [.currency]]
    }
    
    private func updateModel() {
        guard (0 ..< personDataService.members.count).contains(nameIndex) else {
            personDataService.add(name: name, at: nameIndex)
            needToUpdate = true
            return
        }
        guard !name.isEmpty else {
            personDataService.remove(at: nameIndex)
            needToUpdate = true
            return
        }
        guard name == personDataService.name(at: nameIndex) else {
            personDataService.rename(name, at: nameIndex)
            needToUpdate = true
            return
        }
    }
    
    private func reloadTableView() {
        sections = updateSections()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == segueIdentifier,
            let navigationViewController = segue.destination as? UINavigationController,
            let vc = navigationViewController.childViewControllers.first as? GroupListViewController {
                saveGroup()
                vc.dataService = dataService
        }
    }
    
    private func saveGroup() {
        let group = Group(members: personDataService.members, currency: Currency.allCases[currencyIndex])
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
        let cell: UITableViewCell
        switch model {
        case .personEditor(let name):
            let newCell = tableView.dequeueReusableCell(NameInputCell.id, indexPath: indexPath)
            newCell.set(text: name, delegate: self)
            newCell.editingChanged = { [weak self] text in
                guard let `self` = self, let text = text else { return }
                self.name = text
                self.nameIndex = indexPath.row
                self.updateModel()
            }
            cell = newCell
        case .addButton:
            let newCell = tableView.dequeueReusableCell(AddButtonCell.id, indexPath: indexPath)
            newCell.addItemHandler = { [weak self] in
                guard let `self` = self else { return }
                if self.needToUpdate {
                    self.reloadTableView()
                    self.needToUpdate = false
                }
            }
            cell = newCell
        case .currency:
            let newCell = tableView.dequeueReusableCell(CurrencyControlCell.id, indexPath: indexPath)
            newCell.set(currencies: Currency.allCases, currentIndex: currencyIndex)
            newCell.selectedIndexHandler = { [weak self] index in
                self?.currencyIndex = index
            }
            cell = newCell
        }
        return cell
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
