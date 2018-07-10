//
//  Note.swift
//  HowMuch
//
//  Created by Svetlana T on 10.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import Foundation

enum NoteType {
    case forTwo
    case forThree
    case forFour
    
    init(count: Int) {
        switch count {
        case 2: self = .forTwo
        case 3: self = .forThree
        case 4: self = .forFour
        default: self = .forTwo
        }
    }
}

final class Note {
    
    let persons: [Person]
    var type: NoteType {
        return NoteType(count: persons.count)
    }
    
    init(persons: [Person]) {
        self.persons = persons
    }
}
