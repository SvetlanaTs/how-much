//
//  GroupListViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class GroupListViewController: UIViewController {
    enum Cell {
        case group(group: Group)
    }
    
    @IBOutlet private var tableView: UITableView!
    
    private let showPurchaseSegueId = "showPurchaseList"
    private let addGroupSegueId = "showAddGroup"
    private var rows: [Cell] = []
    
    var dataService: DataService!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(TwoMembersCell.id)
        tableView.registerReusableCell(ThreeMembersCell.id)
        tableView.registerReusableCell(FourMembersCell.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    private func reloadTableView() {
        updateRows()
        tableView.reloadData()
    }

    private func updateRows() {
        let groups = dataService.groups
        
        if groups.isEmpty {
            tableView.isHidden = true
            saveState(hasData: false)
            return
        }
        
        var cells: [Cell] = []
        groups.forEach { (group) in
            cells.append(.group(group: group))
        }
        rows = cells
        saveState(hasData: true)
        save(groups: groups)
    }
    
    private func saveState(hasData: Bool) {
        UserDefaults.standard.set(hasData, forKey: Constants.UserDefaults.hasDataKey)
    }
    
    private func save(groups: [Group]) {
        if let data = try? JSONEncoder().encode(groups) {
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.groupKey)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showPurchaseSegueId,
            let vc = segue.destination as? PurchaseListViewController,
            let sender = sender as? Int {
                vc.dataService = dataService
                vc.index = sender
        }
        if segue.identifier == addGroupSegueId, let vc = segue.destination as? AddGroupViewController {
            vc.dataService = dataService
        }
    }
}

extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = rows[indexPath.row]
        let cell: UITableViewCell
        
        switch model {
        case .group(let group):
            switch group.members.count {
            case 2:
                let newCell = tableView.dequeueReusableCell(TwoMembersCell.id, indexPath: indexPath)
                newCell.set(group: group)
                cell = newCell
            case 3:
                let newCell = tableView.dequeueReusableCell(ThreeMembersCell.id, indexPath: indexPath)
                newCell.set(group: group)
                cell = newCell
            case 4:
                let newCell = tableView.dequeueReusableCell(FourMembersCell.id, indexPath: indexPath)
                newCell.set(group: group)
                cell = newCell
            default:
                return UITableViewCell()
            }
        }
        return cell
    }
}

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let model = rows[indexPath.row]
        switch model {
        case .group(_):
            performSegue(withIdentifier: showPurchaseSegueId, sender: indexPath.row)
        }
    }
}
