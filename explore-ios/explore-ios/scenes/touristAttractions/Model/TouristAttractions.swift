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
    func getCountries() -> [String] {
        return attractionsList.map {$0.country};
    }
    func getAttractions(fromCountry country: String) -> [TouristAttraction] {
        return attractionsList.filter ({ return $0.country == country})
    }
}
