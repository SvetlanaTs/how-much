//
//  GroupListViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class GroupListViewController: UIViewController {
    enum GroupCell {
        case twoMembersIn(_ group: Group)
        case threeMembersIn(_ group: Group)
        case fourMembersIn(_ group: Group)
    }
    
    struct GroupList {
        static let baseMembersCellHeight: CGFloat = 105.0
        static let fourMembersCellHeight: CGFloat = 182.0
    }
    
    @IBOutlet private var tableView: UITableView!
    
    var dataService: DataService?
    private var rows: [GroupCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(TwoMembersCell.id)
        tableView.registerReusableCell(ThreeMembersCell.id)
        tableView.registerReusableCell(FourMembersCell.id)
        formRows()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsetsMake(24, 0, 24, 0)
    }
    
    private func formRows() {
        guard let dataService = dataService else { return }
        let groups = dataService.groups
        var cells: [GroupCell] = []
        groups.forEach { (group) in
            switch group.members.count {
                case 2: cells.append(.twoMembersIn(group))
                case 3: cells.append(.threeMembersIn(group))
                case 4: cells.append(.fourMembersIn(group))
                default: cells.append(.twoMembersIn(group))
            }
        }
        rows = cells
    }
}

extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = rows[indexPath.row]
        switch model {
        case .twoMembersIn(let group):
            let cell = tableView.dequeueReusableCell(TwoMembersCell.id, indexPath: indexPath)
            guard let firstPerson = group.members.first, let secondPerson = group.members.last else { return UITableViewCell() }
            cell.firstPersonView.nameLabel.text = firstPerson.name
            cell.firstPersonView.debtLabel.text = firstPerson.amountSpent.description
            cell.secondPersonView.nameLabel.text = secondPerson.name
            cell.secondPersonView.debtLabel.text = secondPerson.amountSpent.description
            return cell
        case .threeMembersIn(let group):
            let cell = tableView.dequeueReusableCell(ThreeMembersCell.id, indexPath: indexPath)
            guard let firstPerson = group.members.first, let thirdPerson = group.members.last else { return UITableViewCell() }
            let secondPerson = group.members[1]
            cell.firstPersonView.nameLabel.text = firstPerson.name
            cell.firstPersonView.debtLabel.text = firstPerson.amountSpent.description
            cell.secondPersonView.nameLabel.text = secondPerson.name
            cell.secondPersonView.debtLabel.text = secondPerson.amountSpent.description
            cell.thirdPersonView.nameLabel.text = thirdPerson.name
            cell.thirdPersonView.debtLabel.text = thirdPerson.amountSpent.description
            return cell
        case .fourMembersIn(let group):
            let cell = tableView.dequeueReusableCell(FourMembersCell.id, indexPath: indexPath)
            guard let firstPerson = group.members.first, let fourthPerson = group.members.last else { return UITableViewCell() }
            let secondPerson = group.members[1]
            let thirdPerson = group.members[2]
            cell.firstPersonView.nameLabel.text = firstPerson.name
            cell.firstPersonView.debtLabel.text = firstPerson.amountSpent.description
            cell.secondPersonView.nameLabel.text = secondPerson.name
            cell.secondPersonView.debtLabel.text = secondPerson.amountSpent.description
            cell.thirdPersonView.nameLabel.text = thirdPerson.name
            cell.thirdPersonView.debtLabel.text = thirdPerson.amountSpent.description
            cell.fourthPersonView.nameLabel.text = fourthPerson.name
            cell.fourthPersonView.debtLabel.text = fourthPerson.amountSpent.description
            return cell
        }
    }
}

extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = rows[indexPath.row]
        switch model {
        case .twoMembersIn(_), .threeMembersIn(_):
            return GroupList.baseMembersCellHeight
        case .fourMembersIn(_):
            return GroupList.fourMembersCellHeight
        }
    }
}
