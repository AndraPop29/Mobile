//
//  Model.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation

class Patient: Codable {
    
    var name = ""
    var id = 0
    
}


class Record: Codable {
    
    var id = 0
    var name = ""
    var patientId = 1
    var type = ""
    var status = ""
    var details = ""
    var date: Double = 0.0
}

class Car: Codable {
    
    var id  = 0
    var name = ""
    var model = ""
    var year = 0
    var km = 0
    
    init(id: Int, name: String, model: String, year: Int, km: Int) {
        self.id = id
        self.name = name
        self.model = model
    //    self.status = status
        self.year = year
        self.km = km
    }
//
    
}

