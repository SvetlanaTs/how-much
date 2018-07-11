//
//  AddGroupViewModel.swift
//  HowMuch
//
//  Created by Svetlana T on 11.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

enum AddGroupSectionType {
    case textField
    case addButton
}

struct AddGroupConstants {
    static let textFieldCellHeight: CGFloat = 64.0
    static let addButtonCellHeight: CGFloat = 56.0
    static let membersMinValue = 2
    static let membersMaxValue = 4
}

final class AddGroupViewModel {
    private var sections: [AddGroupSectionType] = [.textField, .addButton]
    private var members: [Person] = []
    
    private func buildModels(for section: Int) -> [AnyObject] {
        var cellModels: [AnyObject] = []
        
        if sections[section] == .textField {
            for _ in 0...members.count {
                cellModels.append(TextFieldCellModel())
            }
        }
        if sections[section] == .addButton {
            cellModels.append(AddButtonCellModel())
        }
        
        return cellModels
    }
}

extension AddGroupViewModel {
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return buildModels(for: section).count
    }
    
    func modelForCell(at indexPath: IndexPath) -> AnyObject {
        return buildModels(for: indexPath.section)[indexPath.row]
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        let model = buildModels(for: indexPath.section)[indexPath.row]
        if let _ = model as? TextFieldCellModel {
            return AddGroupConstants.textFieldCellHeight
        }
        if let _ = model as? AddButtonCellModel {
            return AddGroupConstants.addButtonCellHeight
        }
        return 0
    }
    
    func add(name: String) {
        let person = Person(name: name, purchases: [])
        members.append(person)
    }
    
    func hasNoMembers() -> Bool {
        return members.isEmpty
    }
    
    func isFullOfMembers() -> Bool {
        return members.count >= AddGroupConstants.membersMaxValue
    }
    
    func canCreateGroup() -> Bool {
        return members.count >= AddGroupConstants.membersMinValue && members.count <= AddGroupConstants.membersMaxValue
    }
    
    func group() -> [Person] {
        return members
    }
}

final class TextFieldCellModel {
    
}

final class AddButtonCellModel {
    
}
