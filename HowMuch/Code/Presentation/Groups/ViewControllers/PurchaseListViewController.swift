//
//  PurchaseListViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 24.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class PurchaseListViewController: UIViewController {
    typealias Section = (header: Header?, cells: [Cell])
    
    enum Header {
        case name(name: String, amountSpent: Decimal)
    }
    
    enum Cell {
        case purchase(purchase: Purchase)
        case addButton
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private let nameHeaderHeight: CGFloat = 54.0
    private let defaultHeaderHeight: CGFloat = 0.0
    private let segueIdentifier = "showPurchase"
    private var sections: [Section] = []
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(PurchaseItemCell.id)
        tableView.registerReusableCell(AddItemCell.id)
        tableView.registerReusableHeaderFooterView(PurchaseSectionHeaderView.id)
        updateSections()
    }

    private func updateSections() {
        sections.removeAll()
        group.members.forEach { (person) in
            let item = Section(header: .name(name: person.name, amountSpent: person.amountSpent), cells: person.purchases.map { .purchase(purchase: $0) })
            sections.append(item)
        }
        let addButtonItem = Section(header: nil, cells: [.addButton])
        sections.append(addButtonItem)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
           let vc = segue.destination as? PurchaseViewController,
           let sender = sender as? Group {
            vc.group = sender
            vc.updateGroupHandler = { [weak self] group in
                guard let `self` = self else { return }
                self.group = group
                self.updateSections()
                self.tableView.reloadData()
            }
        }
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
        let cell: UITableViewCell
        switch model {
        case .purchase(let purchase):
            let newCell = tableView.dequeueReusableCell(PurchaseItemCell.id, indexPath: indexPath)
            newCell.set(purchase: purchase)
            cell = newCell
        case .addButton:
            let newCell = tableView.dequeueReusableCell(AddItemCell.id, indexPath: indexPath)
            newCell.addItemHandler = { [weak self] in
                guard let `self` = self else { return }
                self.performSegue(withIdentifier: self.segueIdentifier, sender: self.group)
            }
            cell = newCell
        }
        return cell
    }
}

extension PurchaseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = sections[section].header
        let view: UIView?

        switch model {
        case .name(let name, let amountSpent)?:
            let newView = tableView.dequeueReusableHeaderFooterView(PurchaseSectionHeaderView.id)
            newView.set(name: name, amountSpent: amountSpent)
            view = newView
        case .none:
            view = nil
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = sections[section].header
        
        switch model {
        case .name(_, _)?:
            return nameHeaderHeight
        case .none:
            return defaultHeaderHeight
        }
    }
}
