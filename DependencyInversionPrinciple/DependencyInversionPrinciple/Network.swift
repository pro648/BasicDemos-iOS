//
//  Network.swift
//  DependencyInversionPrinciple
//
//  Created by ad on 2022/8/1.
//

import UIKit

/*
final class Network {
    private let urlSession = URLSession(configuration: .default)
    
    func getProducts(for userId: String, completion: @escaping ([Product]) -> Void) {
        guard
            let url = URL(string: "baseUrl/products/user/\(userId)")
        else {
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion([Product(name: "Just an example", cost: 1000, image: UIImage())])
            }
        }
    }
}
*/

// Abstraction
protocol NetworkProtocol {
    func getProducts(for userId: String, completion: @escaping ([ProductProtocol]) -> Void)
}

final class Network: NetworkProtocol {
    private let urlSession = URLSession(configuration: .default)
    
    func getProducts(for userId: String, completion: @escaping ([ProductProtocol]) -> Void) {
        guard
            let url = URL(string: "baseURL/products/user/\(userId)")
        else {
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        urlSession.dataTask(with: request) { (data, response, error) in
            completion([Product(name: "Just an example", cost: 1000, image: UIImage())])
        }
    }
}
