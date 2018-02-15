//
//  LocalStorage.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation


enum Keys: String {
    case items, currentPatient, car
}


class LocalStorage {
  
    static func storeCurrent(patient: Patient) {
        print("Storing current patient: \(patient.id)")
        
        let id = patient.id
        
        UserDefaults.standard.set(id, forKey: Keys.currentPatient.rawValue)
    }
    
    static func getCurrentPatientId() -> Int? {
        let id = UserDefaults.standard.integer(forKey: Keys.currentPatient.rawValue)
        
        return id == 0 ? nil : id
    }
    
    static func getCurrentCar() -> Int? {
        let id = UserDefaults.standard.integer(forKey: Keys.car.rawValue)
        
        return id == 0 ? nil : id
    }
    
    static func cleanup() {
        print("Deleting cars")
        
        UserDefaults.standard.removeObject(forKey: Keys.items.rawValue)
    }
    
    static func store(items: [Car]) {
        print("Storing \(items.count) to local device.")
        
        let encoder = JSONEncoder()
        if let archivedData = try? encoder.encode(items) {
            UserDefaults.standard.set(archivedData, forKey: Keys.items.rawValue)
        }
    }
    
    static func storeCar(item: Int) {
        print("Storing \(item) to local device.")
         UserDefaults.standard.set(item, forKey: Keys.car.rawValue)
//        let encoder = JSONEncoder()
//        if let archivedData = try? encoder.encode(item) {
//            UserDefaults.standard.set(archivedData, forKey: Keys.car.rawValue)
//        }
    }
    
    static func retrieveItems() -> [Car] {
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.object(forKey: Keys.items.rawValue) as? Data {
            let items = try? decoder.decode(Array<Car>.self, from: data)
            
            print("Retrieved \(items?.count ?? 0) from local storage.")
            
            return items ?? []
        }
        
        return []
    }
    
}
