//
//  TouristAttractions.swift
//  explore-ios
//
//  Created by Andra Pop on 2017-11-13.
//  Copyright © 2017 andrapop. All rights reserved.
//

import Foundation
import os.log

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
    func saveAttractions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(attractionsList, toFile:TouristAttraction.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Attractions successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save attractions...", log: OSLog.default, type: .error)
        }
    }
    func loadAttractions() -> [TouristAttraction]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TouristAttraction.ArchiveURL.path) as? [TouristAttraction]
    }
    func getTop10Attractions() -> Array<TouristAttraction> {
        let sortedAttractions = attractionsList.sorted(by: {lhs, rhs in
            return lhs.ratingAverage > rhs.ratingAverage
        })
        if(sortedAttractions.count <= 10) {
            return Array(sortedAttractions.prefix(sortedAttractions.count))
        } else {
            return Array(sortedAttractions.prefix(10))
        }
        
    }
}
