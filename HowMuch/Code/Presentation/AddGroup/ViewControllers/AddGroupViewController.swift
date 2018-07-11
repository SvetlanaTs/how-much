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
    
    private let viewModel = AddGroupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "\(TextFieldCell.self)", bundle: nil), forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
        tableView.register(UINib(nibName: "\(AddButtonCell.self)", bundle: nil), forCellReuseIdentifier: "\(AddButtonCell.self)")
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
            return cell
        }
        
        if let _ = model as? AddButtonCellModel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AddButtonCell.self)", for: indexPath) as? AddButtonCell else { return UITableViewCell() }
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
