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
        case person(person: Person)
    }
    
    enum Cell {
        case purchase(purchase: Purchase)
        case addButton
    }
    
    private var convertService: CurrencyConvertService!
    
    @IBOutlet private var tableView: UITableView!
    
    private let nameHeaderHeight: CGFloat = 54.0
    private let defaultHeaderHeight: CGFloat = 0.0
    private let segueIdentifier = "showPurchase"
    private var sections: [Section] = []
    var dataService: DataService!
    var index: Int!
    var currencyService: CurrencyService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(PurchaseItemCell.id)
        tableView.registerReusableCell(AddItemCell.id)
        tableView.registerReusableHeaderFooterView(PurchaseSectionHeaderView.id)
        reloadTableView()
        setConvertService()
    }
    
    private func reloadTableView() {
        updateSections()
        tableView.reloadData()
    }

    private func updateSections() {
        sections.removeAll()
        
        let group = dataService.group(at: index)
        group.members.forEach { (person) in
            let item = Section(header: .person(person: person), cells: person.purchases.map { .purchase(purchase: $0) })
            sections.append(item)
        }
        let addButtonItem = Section(header: nil, cells: [.addButton])
        sections.append(addButtonItem)
    }
    
    private func save(groups: [Group]) {
        if let data = try? JSONEncoder().encode(groups) {
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.groupKey)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
           let vc = segue.destination as? PurchaseViewController,
           let sender = sender as? Group {
            vc.group = sender
            vc.updateGroupHandler = { [weak self] group in
                guard let `self` = self else { return }
                self.dataService.update(group: group, at: self.index)
                self.reloadTableView()
                self.save(groups: self.dataService.groups)
            }
        }
    }
    
    private func setConvertService() {
        currencyService.loadCurrencies { [weak self] currencies in
            self?.updateConvertService(currencies)
        }
    }
    
    private func updateConvertService(_ currencies: [String: Any]) {
        convertService = CurrencyConvertService(currencies: currencies)
    }
    
    @IBAction private func didSelectCurrencyButton(_ sender: UIBarButtonItem) {
        // TODO: replace with actual data
        let dollarAmount = convertService.convert(amount: 13426.07, fromCurrency: .ruble, toCurrency: .dollar)
        let euroAmount = convertService.convert(amount: 4500, fromCurrency: .ruble, toCurrency: .euro)
        let rubleAmount = convertService.convert(amount: 175, fromCurrency: .euro, toCurrency: .ruble)
        let anotherEuroAmount = convertService.convert(amount: dollarAmount, fromCurrency: .dollar, toCurrency: .euro)
        print(dollarAmount.stringFormatted(by: .dollar))
        print(euroAmount.stringFormatted(by: .euro))
        print(rubleAmount.stringFormatted(by: .ruble))
        print(anotherEuroAmount.stringFormatted(by: .euro))
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
        let group = dataService.group(at: index)

        let cell: UITableViewCell
        switch model {
        case .purchase(let purchase):
            let newCell = tableView.dequeueReusableCell(PurchaseItemCell.id, indexPath: indexPath)
            newCell.set(purchase: purchase, currency: group.currency)
            cell = newCell
        case .addButton:
            let newCell = tableView.dequeueReusableCell(AddItemCell.id, indexPath: indexPath)
            newCell.addItemHandler = { [weak self] in
                guard let `self` = self else { return }
                self.performSegue(withIdentifier: self.segueIdentifier, sender: group)
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
        case .person(let person)?:
            let newView = tableView.dequeueReusableHeaderFooterView(PurchaseSectionHeaderView.id)
            let group = dataService.group(at: index)
            newView.set(person: person, currency: group.currency)
            view = newView
        case .none:
            view = nil
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = sections[section].header
        
        switch model {
        case .person(_)?:
            return nameHeaderHeight
        case .none:
            return defaultHeaderHeight
        }
    }
}
