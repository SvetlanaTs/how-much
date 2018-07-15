//
//  DataService.swift
//  HowMuch
//
//  Created by Svetlana T on 13.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class DataService {
    private(set) var members: [Person] = []
    
    func add(name: String, at index: Int) {
        let person = Person(name: name, purchases: [])
        members.insert(person, at: index)
    }
    
    func rename(_ name: String, at index: Int) {
        guard !members.isEmpty else { return }
        let person = Person(name: name, purchases: [])
        members[index] = person
    }
    
    func remove(at index: Int) {
        guard !members.isEmpty else { return }
        members.remove(at: index)
    }
    
    func name(at index: Int) -> String {
        guard !members.isEmpty else { return "" }
        return members[index].name
    }
}
