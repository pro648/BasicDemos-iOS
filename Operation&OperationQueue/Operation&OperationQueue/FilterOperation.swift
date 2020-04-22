//
//  FilterOperation.swift
//  Operation&OperationQueue
//
//  Created by pro648 on 2020/4/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

final class FilterOperation: Operation {
    var outputImage: UIImage?
    private let inputImage: UIImage?
    
    init(image: UIImage? = nil) {
        inputImage = image
        super.init()
    }
    
    override func main() {
        let dependencyImage = dependencies.compactMap { ($0 as? ImageDataProvider)?.image }.first
        
        guard let inputImage = inputImage ?? dependencyImage else { return }
        guard !isCancelled else {
            return
        }
        
        guard let filteredImage = SepiaFilter().applySepiaFilter(inputImage) else {
            print("Failed to apply sepia filter")
            return
        }
        
        guard !isCancelled else {
            return
        }
        
         outputImage = filteredImage
    }
}

extension FilterOperation: ImageDataProvider {
    var image: UIImage? {
        return outputImage
    }
}
