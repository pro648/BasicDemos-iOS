//
//  NetworkImageOperation.swift
//  Operation&OperationQueue
//
//  Created by pro648 on 2020/4/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

typealias ImageOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    var image: UIImage?
    
    private let url: URL
    private let completion: ImageOperationCompletion
    private var task: URLSessionDataTask?
    
    init(url: URL, completion: ImageOperationCompletion = nil) {
        self.url = url
        self.completion = completion
        
        super.init()
    }
    
    convenience init?(string: String, completion: ImageOperationCompletion = nil) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url, completion: completion)
    }
    
    override func main() {
        task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            defer {
                self.state = .finished
            }
            
            guard !self.isCancelled else { return }
            
            if let completion = self.completion {
                completion(data, response, error)
                return
            }
            
            guard error == nil, let data = data else { return }
            
            self.image = UIImage(data: data)
        }
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}

extension NetworkImageOperation: ImageDataProvider {
    
}
