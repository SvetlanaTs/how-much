//
//  AddGroupViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class AddGroupViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let viewModel = AddGroupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(TextFieldCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
    }

    @IBAction func createGroup(_ sender: UIButton) {
        // TODO:
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
            let cell = tableView.dequeueReusableCell(TextFieldCell.id, indexPath: indexPath)
            cell.textField.delegate = self
            return cell
        }
        
        if let _ = model as? AddButtonCellModel {
            let cell = tableView.dequeueReusableCell(AddButtonCell.id, indexPath: indexPath)
            cell.addTextField = { [weak self] in
                self?.tableView.reloadData()
            }
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
            !text.isEmpty else { return }
        viewModel.add(name: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
