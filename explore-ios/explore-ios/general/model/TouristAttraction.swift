//
//  TouristAttraction.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import Foundation
import UIKit

var counter = -1

class TouristAttraction {
    var Id: Int
    var name: String
    var country: String
    var city: String
    var image: UIImage
    
    init(name: String, country: String, city: String, image: UIImage) {
        counter += 1
        self.Id = counter
        self.name = name
        self.country = country
        self.city = city
        self.image = image
    }
    
    init(name: String, country: String, city: String) {
        counter += 1
        self.Id = counter
        self.name = name
        self.country = country
        self.city = city
        self.image = UIImage()
    }
}
