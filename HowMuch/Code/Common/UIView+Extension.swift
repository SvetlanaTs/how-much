//
//  UIView+Extension.swift
//  HowMuch
//
//  Created by Svetlana T on 20.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

extension UIView {
    func makeRoundCorners() {
        layer.cornerRadius = 6.0
    }
}

extension UIView {
    func applyShadow(cornerRadius: CGFloat = 6.0) {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = layer.contentsScale
    }
}
