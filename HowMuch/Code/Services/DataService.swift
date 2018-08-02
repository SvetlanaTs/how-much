//
//  DataService.swift
//  HowMuch
//
//  Created by Svetlana T on 30.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class DataService {
    private(set) var groups: [Group]
    
    init(groups: [Group]) {
        self.groups = groups
    }
    
    func group(at index: Int) -> Group {
        return groups[index]
    }
    
    func add(group: Group) {
        groups.append(group)
    }
    
    func remove(at index: Int) {
        groups.remove(at: index)
    }
    
    func update(group: Group, at index: Int) {
        groups.remove(at: index)
        groups.insert(group, at: index)
    }
}
