//
//  PurchaseListViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 24.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class PurchaseListViewController: UIViewController {
    typealias SectionItem = (header: Header, cells: [Cell])
    
    enum Header {
        case name(name: String)
        case none
    }
    
    enum Cell {
        case purchase(purchase: Purchase)
        case addButton
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private var sections: [SectionItem] = []
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(PurchaseItemCell.id)
        tableView.registerReusableCell(AddButtonCell.id)
        updateSections()
    }
    
    private func updateSections() {
        group.members.forEach { (person) in
            let item = SectionItem(header: .name(name: person.name), cells: person.purchases.map { .purchase(purchase: $0) })
            sections.append(item)
        }
        let addButtonItem = SectionItem(header: .none, cells: [.addButton])
        sections.append(addButtonItem)
    }
}

extension PurchaseListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        switch model {
        case .purchase(let purchase):
            let cell = tableView.dequeueReusableCell(PurchaseItemCell.id, indexPath: indexPath)
            cell.set(purchase: purchase)
            return cell
        case .addButton:
            let cell = tableView.dequeueReusableCell(AddButtonCell.id, indexPath: indexPath)
            cell.set(title: "Добавить покупку")
            cell.addItem = {
                print("TODO: add purchase")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section].header
        switch model {
        case .name(let name):
            return name
        case .none:
            return nil
        }
    }
}
