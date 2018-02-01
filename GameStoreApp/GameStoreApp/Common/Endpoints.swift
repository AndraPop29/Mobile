//
//  Endpoints.swift
//  GameStoreApp
//
//  Created by Andra Pop on 2018-01-31.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation
import Alamofire


enum Endpoint {
    
    static let baseURL = "http://localhost:4001"
    
    case getAllItems
    case getAllClientItems
    case deleteItem(id: Int)
    case addItem(name: String, quantity: Int, type: String, status: String)
    case updateItem(id: Int, name: String, quantity: Int, type: String, status: String)
    case buyItem(id: Int, quantity: Int)
    case returnItem(id: Int)
    case rentItem(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .deleteItem: return .post
        case .addItem: return .post
        case .updateItem: return .post
        case .buyItem: return .post
        case .returnItem: return .post
        case .rentItem: return .post
        default: return .get
        }
    }
    
    
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
            
        case .updateItem:
            return Endpoint.baseURL + "/updateGame"
            
        case .buyItem:
            return Endpoint.baseURL + "/buyGame"
        
        case .returnItem:
            return Endpoint.baseURL + "/returnGame"
            
        case .rentItem:
            return Endpoint.baseURL + "/rentGame"
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
        case .updateItem(let id, let name, let quantity, let type, let status):
            return [
                "id": id,
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
            
        default: return nil
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
