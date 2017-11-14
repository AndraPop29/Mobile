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
    var city: String
    var imageName: String
    
    init(name: String, country: String, city: String, imageName: String) {
        self.name = name
        self.country = country
        self.city = city
        self.imageName = imageName
    }
}
