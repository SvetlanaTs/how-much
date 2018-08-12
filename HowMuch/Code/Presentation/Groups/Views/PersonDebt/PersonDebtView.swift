//
//  PersonDebtView.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

final class PersonDebtView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var debtLabel: UILabel!
    @IBOutlet var beaconView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        Bundle.main.loadNibNamed("PersonDebtView", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
