//
//  TouristAttraction.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import Foundation
import UIKit

class TouristAttraction {
    var name: String
    var country: String
    var city: String
    var image: UIImage
    
    init(name: String, country: String, city: String, image: UIImage) {
        self.name = name
        self.country = country
        self.city = city
        self.image = image
    }
}
