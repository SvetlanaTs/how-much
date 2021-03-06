//
//  DataService.swift
//  HowMuch
//
//  Created by Svetlana T on 23.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class PersonDataService {
    private(set) var members: [Person] = []
    
    func add(name: String, at index: Int) {
        let person = Person(name: name, purchases: [], debt: 0.0)
        members.insert(person, at: index)
    }
    
    func rename(_ name: String, at index: Int) {
        let person = Person(name: name, purchases: [], debt: 0.0)
        members[index] = person
    }
    
    func remove(at index: Int) {
        members.remove(at: index)
    }
    
    func name(at index: Int) -> String {
        return members[index].name
    }
}
