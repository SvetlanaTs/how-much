//
//  HowMuchTests.swift
//  HowMuchTests
//
//  Created by Svetlana T on 09.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import XCTest
@testable import HowMuch

class HowMuchTests: XCTestCase {
    func testThreeMembersHaveEqualDebts() {
        let members: [Person] = [
            Person(name: "A", purchases: [Purchase(title: "P", spent: 220, date: Date())], debt: 0),
            Person(name: "B", purchases: [Purchase(title: "R", spent: 520, date: Date())], debt: 0),
            Person(name: "C", purchases: [Purchase(title: "Q", spent: 160, date: Date())], debt: 0)
        ]
        let group = Group(members: members, currency: .euro)
        let debtService = DebtDataService(group: group)
        let payments = debtService.payments()
        
        XCTAssertEqual(payments[0], Payment(payerId: 2, id: 1, debt: 140))
        XCTAssertEqual(payments[1], Payment(payerId: 0, id: 1, debt: 80))
    }
    
    func testAnotherThreeMembersHaveEqualDebts() {
        let members: [Person] = [
            Person(name: "A", purchases: [Purchase(title: "P", spent: 100, date: Date())], debt: 0),
            Person(name: "B", purchases: [Purchase(title: "R", spent: 0, date: Date())], debt: 0),
            Person(name: "C", purchases: [Purchase(title: "Q", spent: 50, date: Date())], debt: 0)
        ]
        let group = Group(members: members, currency: .euro)
        let debtService = DebtDataService(group: group)
        let payments = debtService.payments()
        
        XCTAssertEqual(payments[0], Payment(payerId: 1, id: 0, debt: 50))
    }
    
    func testMembersHaveNoDebts() {
        let members: [Person] = [
            Person(name: "A", purchases: [Purchase(title: "P", spent: 0, date: Date())], debt: 0),
            Person(name: "B", purchases: [Purchase(title: "R", spent: 0, date: Date())], debt: 0),
            Person(name: "C", purchases: [Purchase(title: "Q", spent: 0, date: Date())], debt: 0),
            Person(name: "D", purchases: [Purchase(title: "S", spent: 0, date: Date())], debt: 0)
        ]
        let group = Group(members: members, currency: .euro)
        let debtService = DebtDataService(group: group)
        let payments = debtService.payments()
        
        XCTAssertTrue(payments.isEmpty)
    }
}
