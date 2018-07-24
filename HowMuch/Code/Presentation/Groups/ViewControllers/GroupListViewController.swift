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
    
    private let segueIdentifier = "showPurchase"
    private var rows: [Cell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(TwoMembersCell.id)
        tableView.registerReusableCell(ThreeMembersCell.id)
        tableView.registerReusableCell(FourMembersCell.id)
        updateRows()
    }
    
    private func updateRows() {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsConstants.groupKey) else {
            tableView.isHidden = true
            UserDefaults.standard.set(false, forKey: UserDefaultsConstants.hasDataKey)
            return
        }
        if let groups = try? JSONDecoder().decode([Group].self, from: data) {
            var cells: [Cell] = []
            groups.forEach { (group) in
                cells.append(.group(group: group))
            }
            rows = cells
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.hasDataKey)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let vc = segue.destination as? PurchaseListViewController,
                let sender = sender as? Group else { return }
            vc.group = sender
        }
    }
}

extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = rows[indexPath.row]
        switch model {
        case .group(let group):
            switch group.members.count {
            case 2:
                let cell = tableView.dequeueReusableCell(TwoMembersCell.id, indexPath: indexPath)
                cell.set(group: group)
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(ThreeMembersCell.id, indexPath: indexPath)
                cell.set(group: group)
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(FourMembersCell.id, indexPath: indexPath)
                cell.set(group: group)
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
}

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let model = rows[indexPath.row]
        switch model {
        case .group(let group):
            performSegue(withIdentifier: segueIdentifier, sender: group)
        }
    }
}
