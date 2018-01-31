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
    
    static let baseURL = "http://192.168.8.104:4001"
    
    case getAllItems
    case deleteItem(id: Int)
    case addItem(name: String, quantity: Int, type: String, status: String)
    
    var method: HTTPMethod {
        switch self {
        case .deleteItem: return .post
        case .addItem: return .post
            
        default: return .get
        }
    }
    
    
    var path: String {
        switch self {
        case .getAllItems:
            return Endpoint.baseURL + "/all"
            
        case .deleteItem:
            return Endpoint.baseURL + "/removeGame"
            
        case .addItem:
            return Endpoint.baseURL + "/addGame"
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
            
        case .deleteItem(let id) : return ["id": id]
            
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
