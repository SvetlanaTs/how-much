//
//  DebtDataService.swift
//  HowMuch
//
//  Created by Svetlana T on 03.08.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

struct Payment: Equatable {
    let payerId: Int
    let id: Int
    let debt: Decimal
    
    static func ==(lhs: Payment, rhs: Payment) -> Bool {
        return lhs.payerId == rhs.payerId &&
            lhs.id == rhs.id &&
            lhs.debt == rhs.debt
    }
}

final class DebtDataService {
    private var group: Group
    private var average: Decimal {
        let total = group.members.reduce(0.0) { $0 + $1.amountSpent }
        return total / Decimal(group.members.count)
    }
    private var debtArray: [Decimal] {
        let averageAmount = average
        return group.members.map { averageAmount - $0.amountSpent }
    }

    init(group: Group) {
        self.group = group
    }
    
    func payments() -> [Payment] {
        var payments: [Payment] = []
        var debts = Dictionary(uniqueKeysWithValues: zip(0...Int.max, debtArray))
        
        while !debts.isEmpty {
            guard let maxDebt = debts.max(by: { $0.value < $1.value }),
            let minDebt = debts.min(by: { $0.value < $1.value }),
                maxDebt.value > 0,
                minDebt.value < 0 else { break }
            
            let debt = min(maxDebt.value, -minDebt.value)
            payments.append(Payment(payerId: maxDebt.key, id: minDebt.key, debt: debt))
            
            debts[maxDebt.key] = maxDebt.value - debt
            debts[minDebt.key] = minDebt.value + debt
            
            guard let newMaxDebt = debts[maxDebt.key],
                let newMinDebt = debts[minDebt.key],
                let maxIndex = debts.index(forKey: maxDebt.key),
                let minIndex = debts.index(forKey: minDebt.key) else { break }
            
            if newMaxDebt <= Decimal(0) {
                debts.remove(at: maxIndex)
            }
            
            if newMinDebt >= Decimal(0) {
                debts.remove(at: minIndex)
            }
        }
        
        return payments
    }
}
