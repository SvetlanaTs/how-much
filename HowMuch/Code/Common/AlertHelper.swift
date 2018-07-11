//
//  AlertHelper.swift
//  HowMuch
//
//  Created by Svetlana T on 11.07.2018.
//  Copyright © 2018 Nemis. All rights reserved.
//

import UIKit

typealias CancelAction = ((UIAlertAction) -> Void)?

final class AlertHelper {
    static func applyAlert(title: String, message: String, cancelAction: CancelAction) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: cancelAction))
        return alertController
    }
}
