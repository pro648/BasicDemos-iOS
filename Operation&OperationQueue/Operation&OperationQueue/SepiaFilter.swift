//
//  SepiaFilter.swift
//  Operation&OperationQueue
//
//  Created by pro648 on 2020/4/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class SepiaFilter {
    private static let context = CIContext()
    
    func applySepiaFilter(_ image: UIImage) -> UIImage? {
        guard let data = image.pngData() else { return nil }
        let inputImage = CIImage(data: data)
        
//        let context = CIContext(options: nil)
        
        guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "inputIntensity")
        
        guard let outputImage = filter.outputImage,
            let outImage = SepiaFilter.context.createCGImage(outputImage, from: outputImage.extent)
            else {
                return nil
        }
        
        return UIImage(cgImage: outImage)
    }
}
