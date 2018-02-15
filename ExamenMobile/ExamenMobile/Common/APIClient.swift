//
//  APIClient.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD
import SwiftyJSON

struct APIClient {
    static func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> Void) {
        
        let path = endpoint.path
        let method = endpoint.method
        let parameters = endpoint.body
        let encoding = JSONEncoding.default
        let headers = endpoint.headers
        print(endpoint)
        Alamofire.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseData { response in
                
                
                print("Got response with status: \(response.response?.statusCode ?? -1)")
                
                switch response.result {
                case .success(let value):
                    
                    if response.response?.statusCode != 200 {
                        let message = String(data: value, encoding: .utf8)
                        
                        let error = NSError(domain: "a", code: 0, userInfo: ["localizedDescription":message])
                        
                        completion(.failure(error))
                        
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()

                        let decodedObject = try decoder.decode(T.self, from: value)
                        
                    
                        
                        completion(.success(decodedObject))
                        
                    } catch let error {
                        
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                    print("Network error: \(error.localizedDescription)")
                }
                
        }
    }
    
    static func requestData(endpoint: Endpoint, completion: @escaping (Result<String>) -> Void) {
        let path = endpoint.path
        let method = endpoint.method
        let parameters = endpoint.body
        let encoding = JSONEncoding.default
        let headers = endpoint.headers
        
        print(endpoint)
        
        Alamofire.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .responseData { response in
                
                print("Got response with status: \(response.response?.statusCode ?? -1)")
                
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        completion(.success(""))
                    } else {
                        completion(.failure(NSError()))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                    print("Network error: \(error.localizedDescription)")
                }
                
        }
    }

}


