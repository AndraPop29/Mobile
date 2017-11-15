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
    func updateAttraction(withId id: Int, attraction: TouristAttraction) {
        for i in 0...attractionsList.count - 1 {
            if attractionsList[i].Id == id {
                attractionsList[i] = attraction
            }
        }
    }
    func addAttraction(attraction: TouristAttraction) {
        if(!attractionsList.contains(where: {$0.name == attraction.name})) {
            attractionsList.append(attraction)
        }
    }
}
