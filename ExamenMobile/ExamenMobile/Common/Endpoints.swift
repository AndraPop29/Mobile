//
//  Endpoints.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

enum Endpoint {
    
    static let baseURL = "http://192.168.8.102:4024"
    
    // other
    case getAllItems
    case getAllClientItems
    case deleteItem(id: Int)
    case addItem(name: String, quantity: Int, type: String, status: String)
    case updateItem(id: Int, name: String, status: String, year: Int)
    case buyItem(id: Int, quantity: Int)
    case returnItem(id: Int)
    case rentItem(id: Int)
    
    
    // hospital
    
    case patients
    case records(id: Int)
    case details(id: Int)
    case nuke
    case deleteCar(id: Int)
    case addRecord(record: Record)
    
    //exam
    
    case cars
    case km(id: Int, km: Int)
    case add(name: String, model: String, year: Int)
    
    
    var path: String {
        
        switch self {
            
        case .getAllClientItems:
            return Endpoint.baseURL + "/games"
        case .getAllItems:
            return Endpoint.baseURL + "/all"
            
        case .deleteItem:
            return Endpoint.baseURL + "/removeGame"
            
        case .addItem:
            return Endpoint.baseURL + "/addGame"
            

            
        case .buyItem:
            return Endpoint.baseURL + "/buyGame"
            
        case .returnItem:
            return Endpoint.baseURL + "/returnGame"
            
        case .rentItem:
            return Endpoint.baseURL + "/rentGame"
        
        
            
        case .patients: return Endpoint.baseURL + "/patients"
        case .records(let id): return Endpoint.baseURL + "/records/\(id)"
        case .details(let id): return Endpoint.baseURL + "/detail/\(id)"
        case .nuke: return Endpoint.baseURL + "/nuke"
        case .deleteCar(let id): return Endpoint.baseURL + "/car/\(id)"
        case .addRecord: return Endpoint.baseURL + "/add"
            
        case .cars: return Endpoint.baseURL + "/cars"
        case .km: return Endpoint.baseURL + "/km"
        case .updateItem: return Endpoint.baseURL + "/modify"
            
        case .add: return Endpoint.baseURL + "/add"
            
            
            
        }
    }
    
    var body: [String:Any]? {
        switch self {
      
        case .addItem(let name, let quantity, let type, let status):
            return [
                "name": name,
                "quantity": quantity,
                "type": type,
                "status": status
            ]

        case .buyItem(let id, let quantity):
            return [
                "id": id,
                "quantity": quantity
            ]
        case .deleteItem(let id) : return ["id": id]
            
        case .returnItem(let id) : return ["id": id]
            
        case .rentItem(let id) : return ["id": id]
            
        case .addRecord(let record):
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(record) {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                return json as? [String:Any]
            }
            
            return nil
        
        case .km(let id, let km):
            return [
                "id": id,
                "km": km

            ]
            
        case .updateItem(let id, let name, let status, let year):
            return [
                "id": id,
                "name": name,
                "status": status,
                "year": year
            ]
            
        case .add(let name, let model, let year):
            return [
                "name": name,
                "model": model,
                "year": year
            ]
            
            
        default: return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .nuke, .deleteCar: return .delete
        case .addRecord: return .post
        case .deleteItem: return .post
        case .addItem: return .post
        case .updateItem: return .post
        case .buyItem: return .post
        case .returnItem: return .post
        case .rentItem: return .post
        case .km: return .post
        case .updateItem: return .post
        case .add: return .post
            
        default: return .get
        }
    }
    
    var headers: [String:String] {
        let headers: [String:String] = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            ]
        
        return headers
    }
    
    
    
}


extension Endpoint: CustomStringConvertible {
    
    var description: String {
        return "Request sent - url: \(self.path) ; method: \(self.method)"
    }
}
