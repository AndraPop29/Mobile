//
//  TouristAttraction.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import Foundation

class TouristAttraction {
    var name: String
    var country: String
    var imageName: String
    
    init(name: String, country: String, imageName: String) {
        self.name = name
        self.country = country
        self.imageName = imageName
    }
}
