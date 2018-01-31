//
//  EmptyDataSourceView.swift
//  GameStoreApp
//
//  Created by Andra Pop on 2018-01-31.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit

class EmptyDataSourceView: UIView {

    
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        self.backgroundColor = .white
        
        let button = Button(frame: self.bounds)
        button.backgroundColor = .clear
        button.onPress = {
            self.onTap?()
        }
        
        let textLabel = UILabel()
        textLabel.textColor = .darkGray
        textLabel.font = UIFont.systemFont(ofSize: 14.0)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.text = "We're sorry but you seem to have issues with your internet connection. Press here to retry establishing a connection."
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        
        
        self.addSubview(button)
        button.center = self.center
        
    }
}
