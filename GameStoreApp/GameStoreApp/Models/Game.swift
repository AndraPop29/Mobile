//
//  Game.swift
//  GameStoreApp
//
//  Created by Andra Pop on 2018-01-31.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation

enum Type: String {
    case action, adventure, board
}

enum Status: String {
    case available, sold, rent
}

final class Game: Codable {
    
    var id: Int
    var name: String
    var quantity: Int
    var type: Type
    var status: Status
    
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
    
}


