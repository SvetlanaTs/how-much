//
//  Reusable.swift
//  HowMuch
//
//  Created by Svetlana T on 12.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

public enum Reusable<CellType> {
    case `class`(id: String)
    case nib(id: String, name: String, bundle: Bundle?)
    
    public var id: String {
        switch self {
            case .class(let id): return id
            case .nib(let id, _, _): return id
        }
    }
}

public extension UITableView {
    public func registerReusableCell<CellType: UITableViewCell>(_ reusable: Reusable<CellType>) {
        switch reusable {
            case .class(let id):
                register(CellType.self, forCellReuseIdentifier: id)
            case .nib(let id, let name, let bundle):
                let nib = UINib(nibName: name, bundle: bundle)
                register(nib, forCellReuseIdentifier: id)
        }
    }
    
    public func dequeueReusableCell<CellType: UITableViewCell>(_ reusable: Reusable<CellType>) -> CellType {
        let anyCell = dequeueReusableCell(withIdentifier: reusable.id)
        guard let cell = anyCell as? CellType else {
            fatalError("Invalid table view cell type. Expected \(CellType.self), but received \(type(of: anyCell))")
        }
        return cell
    }
    
    public func dequeueReusableCell<CellType: UITableViewCell>(_ reusable: Reusable<CellType>, indexPath: IndexPath) -> CellType {
        let anyCell = dequeueReusableCell(withIdentifier: reusable.id, for: indexPath)
        guard let cell = anyCell as? CellType else {
            fatalError("Invalid table view cell type. Expected \(CellType.self), but received \(type(of: anyCell))")
        }
        return cell
    }
}
