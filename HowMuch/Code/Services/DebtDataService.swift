//
//  DebtDataService.swift
//  HowMuch
//
//  Created by Svetlana T on 03.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class DebtDataService {
    private var group: Group
    private var averageAmountSpent: Decimal {
        return group.members.map { $0.amountSpent }
            .reduce(0.0, +) / Decimal(group.members.count)
    }
    
    init(group: Group) {
        self.group = group
    }

    func debtGroup() -> Group {
        let members = group.members
        var debtMembers: [Person] = []
        
        for var person in members {
            let debt = averageAmountSpent - person.amountSpent
            person.debt = debt
            debtMembers.append(person)
        }
        return Group(members: debtMembers)
    }
}
