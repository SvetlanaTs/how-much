//
//  PurchaseViewController.swift
//  HowMuch
//
//  Created by Svetlana T on 25.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class PurchaseViewController: UIViewController {
    var updateGroupHandler: ((Group) -> Void)?
    private var name: String = ""
    private var spent: Decimal = 0
    
    var group: Group!
    
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSegmentedControl()
    }
    
    private func updateSegmentedControl() {
        segmentedControl.removeAllSegments()
        for (index, person) in group.members.enumerated() {
            segmentedControl.insertSegment(withTitle: person.name, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }

    @IBAction func titleEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else { return }
        name = text
    }
    
    @IBAction func spentEditingChanged(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty, let sum = Decimal(string: text) else { return }
        spent = sum
    }
    
    @IBAction func didSelect(_ sender: UIButton) {
        guard let group = groupWithPurchase() else { return }
        updateGroupHandler?(group)
        dismiss(animated: true, completion: nil)
    }
    
    private func groupWithPurchase() -> Group? {
        guard !name.isEmpty, spent > 0 else {
            print("fill in the fields")
            return nil
        }
        let purchase = Purchase(title: name, spent: spent, date: Date())
        var person = group.members[segmentedControl.selectedSegmentIndex]
        person.purchases.append(purchase)
        
        var members = group.members
        members.remove(at: segmentedControl.selectedSegmentIndex)
        members.insert(person, at: segmentedControl.selectedSegmentIndex)
        
        return Group(members: members, currency: group.currency)
    }
}
