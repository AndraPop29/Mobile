//
//  Button.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {
    
    var onPress: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addTarget(self, action: #selector(onPressAction), for: .touchUpInside)
    }
    
    @objc func onPressAction() {
        self.onPress?()
    }
}
