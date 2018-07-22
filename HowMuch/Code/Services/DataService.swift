//
//  DataService.swift
//  HowMuch
//
//  Created by Svetlana T on 13.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

final class DataService {
    private(set) var groups: [Group] = []
    
    func add(group: Group) {
        groups.append(group)
    }
    
    func group(at index: Int) -> Group {
        return groups[index]
    }
}
