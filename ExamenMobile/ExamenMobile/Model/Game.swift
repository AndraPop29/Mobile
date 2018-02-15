//
//  Game.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation

import Foundation
import os.log

enum Type: String {
    case action, adventure, board
}

enum Status: String {
    case available, sold, rent
}

struct PropertyKey {
    static let id = "id"
    static let name = "name"
    static let status = "status"
    static let quantity = "quantity"
    static let type = "type"
}

final class Game: NSObject, NSCoding, Codable {
    
    var id: Int
    var name: String
    var quantity: Int
    var type: Type
    var status: Status
    override init() {
        self.id = 0
        self.name = ""
        self.quantity = 0
        self.type = .action
        self.status = .available
    }
    
    init(id: Int, name: String, quantity: Int, type: Type, status: Status) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.type = type
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, type, quantity
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.quantity = try values.decode(Int.self, forKey: .quantity)
        
        let statusRawvalue = try values.decode(String.self, forKey: .status)
        self.status = Status(rawValue: statusRawvalue)!
        
        let typeRawvalue = try values.decode(String.self, forKey: .type)
        self.type = Type(rawValue: typeRawvalue)!
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.type.rawValue, forKey: .type)
        try container.encode(self.status.rawValue, forKey: .status)
        try container.encode(self.quantity, forKey: .quantity)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: PropertyKey.id)
        aCoder.encode(self.name, forKey: PropertyKey.name)
        aCoder.encode(self.type.rawValue, forKey: PropertyKey.type)
        aCoder.encode(self.status.rawValue, forKey: PropertyKey.status)
        aCoder.encode(self.quantity, forKey: PropertyKey.quantity)
        
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let decodedName = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a attraction object.", log: OSLog.default, type: .debug)
            return nil
        }
        let decodedId = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let decodedType = aDecoder.decodeObject(forKey: PropertyKey.type) as! String
        let decodedStatus = aDecoder.decodeObject(forKey: PropertyKey.status) as! String
        let decodedQuantity = aDecoder.decodeInteger(forKey: PropertyKey.quantity)
        self.init(id: decodedId, name: decodedName, quantity: decodedQuantity, type: Type.init(rawValue: decodedType)!, status: Status.init(rawValue: decodedStatus)!)
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("boughtGames")
    static let ArchiveURL2 = DocumentsDirectory.appendingPathComponent("rentedGames")
    
    
}
