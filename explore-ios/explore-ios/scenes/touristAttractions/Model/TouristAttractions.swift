//
//  TouristAttractions.swift
//  explore-ios
//
//  Created by Andra Pop on 2017-11-13.
//  Copyright © 2017 andrapop. All rights reserved.
//

import Foundation

class TouristAttractions {
    var attractionsList = [TouristAttraction]()
    static let shared = TouristAttractions()
    private init(){}
}
