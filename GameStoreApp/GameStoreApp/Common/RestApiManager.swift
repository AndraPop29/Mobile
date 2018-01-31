//
//  RestApiManager.swift
//  GameStoreApp
//
//  Created by Andra Pop on 2018-01-31.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire


final class RestApiManager {
    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> Void) {
        let path = endpoint.path
        let method = endpoint.method
        let parameters = endpoint.body
        let encoding = JSONEncoding.default
        let headers = endpoint.headers
        
        Alamofire.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData {
            response in
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    
                    do {
                        let decodedObject = try decoder.decode(T.self, from: value)
                        
                        completion(.success(decodedObject))
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                    
                case .failure(let error): completion(.failure(error))
                }
            }
    
    }
}




