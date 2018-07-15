//
//  GroupListViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class GroupListViewController: UIViewController {
    
    var groups: [Group]?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let groups = groups else { return }
        groups.forEach{ $0.members.forEach{ print($0.name) }}
    }
}
