//
//  DebtDataService.swift
//  HowMuch
//
//  Created by Svetlana T on 03.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class DebtDataService {
    static func getDebtGroup(_ group: Group) -> DebtGroup {
        var sortedMembers: [Debtor] = []
        var debtors: [Debtor] = []
        var creditors: [Debtor] = []
        let arrows: [Arrow]
        
        let members = getDebtors(group)
        members.forEach { member in
            member.isDebtor ? debtors.append(member) : creditors.append(member)
        }
        
        switch members.count {
        case 2:
            sortedMembers = members
            let angle: CGFloat = sortedMembers[0].isDebtor ? .pi / 2 : -(.pi / 2)
            let arrow = Arrow(angle: angle)
            let newArrows = [arrow]
            arrows = newArrows
        case 3:
            if debtors.count > creditors.count {
                sortedMembers = debtors
                sortedMembers.insert(creditors[0], at: 1)
                
                let leftArrow = Arrow(angle: .pi / 2)
                let rightArrow = Arrow(angle: -(.pi / 2))
                let newArrows = [leftArrow, rightArrow]
                arrows = newArrows
            } else {
                sortedMembers = creditors
                if debtors.count > 0 {
                    sortedMembers.insert(debtors[0], at: 1)
                }
                
                let leftArrow = Arrow(angle: -(.pi / 2))
                let rightArrow = Arrow(angle: .pi / 2)
                let newArrows = [leftArrow, rightArrow]
                arrows = newArrows
            }
        default:
            return DebtGroup(debtors: members, arrows: [])
        }
        return DebtGroup(debtors: sortedMembers, arrows: arrows)
    }
    
    private static func getDebtors(_ group: Group) -> [Debtor] {
        let averageAmount = averageAmountSpent(in: group)
        let consistsOfTwo: Bool = (group.members.count == 2)
        var debtors: [Debtor] = []
        
        group.members.forEach { person in
            var debt = averageAmount - person.amountSpent
            if consistsOfTwo {
                debt = debt > 0 ? debt : 0.0
            }
            let debtor = Debtor(person: person, debt: debt)
            debtors.append(debtor)
        }
        return debtors
    }
    
    private static func averageAmountSpent(in group: Group) -> Decimal {
        let sums = group.members.map { $0.amountSpent }
        return sums.reduce(0.0, +) / Decimal(group.members.count)
    }
}

struct Debtor {
    let person: Person
    let debt: Decimal
    var isDebtor: Bool {
        return debt > 0.0
    }
}

struct Arrow {
    let angle: CGFloat
}

struct DebtGroup {
    let debtors: [Debtor]
    let arrows: [Arrow]
}
