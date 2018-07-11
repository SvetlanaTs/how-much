//
//  AddGroupViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class AddGroupViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    private let viewModel = AddGroupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        tableView.register(UINib(nibName: "\(TextFieldCell.self)", bundle: nil), forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(UINib(nibName: "\(AddButtonCell.self)", bundle: nil), forCellReuseIdentifier: "\(AddButtonCell.self)")
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func displayNoFriendsAlert() {
        let alertController = AlertHelper.applyAlert(title: "", message: "Добавьте друга", cancelAction: nil)
        present(alertController, animated: true, completion: nil)
    }
    
    private func displayFullOfFriendsAlert() {
        let alertController = AlertHelper.applyAlert(title: "", message: "В компании слишком много друзей", cancelAction: nil)
        present(alertController, animated: true, completion: nil)
    }
}

extension AddGroupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.modelForCell(at: indexPath)
        
        if let _ = model as? TextFieldCellModel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.reuseIdentifier, for: indexPath) as? TextFieldCell else { return UITableViewCell() }
            cell.textField.delegate = self
            cell.textField.becomeFirstResponder()
            cell.clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
            return cell
        }
        
        if let _ = model as? AddButtonCellModel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddButtonCell.self)", for: indexPath) as? AddButtonCell else { return UITableViewCell() }
            cell.addButton.addTarget(self, action: #selector(addTextField), for: .touchUpInside)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension AddGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(at: indexPath)
    }
}

extension AddGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        if text.isEmpty && viewModel.hasNoMembers() {
            displayNoFriendsAlert()
            return false
        }
        
        viewModel.add(name: text)
        textField.resignFirstResponder()
        return true
    }
}

extension AddGroupViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func addTextField() {
        if viewModel.hasNoMembers() {
            displayNoFriendsAlert()
            return
        }
        
        if viewModel.isFullOfMembers() {
            displayFullOfFriendsAlert()
            return
        }
        
        tableView.reloadData()
    }
    
    @objc func clearTextField() {
        // TODO: - clear
    }
    
    @objc func goNext() {
        let group = viewModel.group()
        group.forEach { person in
            print("\(person.name)")
        }
    }
}
