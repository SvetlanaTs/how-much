//
//  DataService.swift
//  HowMuch
//
//  Created by Svetlana T on 13.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class DataService {
    private(set) var members: [String] = []
    
    func add(name: String) {
        members.append(name)
    }
    
    func name(at index: Int) -> String {
        return members.isEmpty ? "" : members[index]
    }
}
