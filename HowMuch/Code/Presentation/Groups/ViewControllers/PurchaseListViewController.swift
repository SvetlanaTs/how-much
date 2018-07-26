//
//  PurchaseListViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 24.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class PurchaseListViewController: UIViewController {
    typealias SectionItem = (header: Header?, cells: [Cell])
    
    enum Header {
        case name(name: String, amountSpent: Decimal)
    }
    
    enum Cell {
        case purchase(purchase: Purchase)
        case addButton
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private let segueIdentifier = "showPurchase"
    private var sections: [SectionItem] = []
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(PurchaseItemCell.id)
        tableView.registerReusableCell(AddItemCell.id)
        updateSections()
    }

    private func updateSections() {
        sections.removeAll()
        group.members.forEach { (person) in
            let item = SectionItem(header: .name(name: person.name, amountSpent: person.amountSpent), cells: person.purchases.map { .purchase(purchase: $0) })
            sections.append(item)
        }
        let addButtonItem = SectionItem(header: nil, cells: [.addButton])
        sections.append(addButtonItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
            let vc = segue.destination as? PurchaseViewController,
            let sender = sender as? Group {
            vc.delegate = self
            vc.group = sender
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
        guard let views = Bundle.main.loadNibNamed("PurchaseSectionHeaderView", owner: self, options: nil),
            let view = views.first as? PurchaseSectionHeaderView else { return nil }
        
        switch model {
        case .name(let name, let amountSpent)?:
            view.nameLabel.text = name
            view.amountSpentLabel.text = amountSpent.description
        case .none:
            return nil
        }
        return view
    }
}

extension PurchaseListViewController: PurchaseDelegate {
    func update(group: Group) {
        self.group = group
        updateSections()
        tableView.reloadData()
    }
}
