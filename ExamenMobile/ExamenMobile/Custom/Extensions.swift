//
//  Extensions.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func show(message: String, on vc: UIViewController, action: ((UIAlertAction) -> Void)? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: action)
        controller.addAction(action)
        vc.present(controller, animated: true, completion: nil)
    }
}
