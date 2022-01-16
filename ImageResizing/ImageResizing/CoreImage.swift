//
//  CoreImage.swift
//  ImageResizing
//
//  Created by ad on 2022/1/15.
//

import Foundation
import CoreImage
import UIKit

enum CoreImage {
    static let sharedContext = CIContext(options: [.useSoftwareRenderer : false])
    
    static func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        precondition(size != .zero)
        
        guard
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let imageWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat,
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat
        else {
            return nil
        }
        
        let scale = max(size.width, size.height) / max(imageWidth, imageHeight)
        guard scale >= 0, !scale.isInfinite, !scale.isNaN else { return nil }
        
        let aspectRatio = imageWidth / imageHeight
        guard aspectRatio >= 0, !aspectRatio.isInfinite, !aspectRatio.isNaN else { return nil }
        
        return resizedImage(at: url, scale: scale, aspectRatio: aspectRatio)
    }
    
    static func resizedImage(at url: URL, scale: CGFloat, aspectRatio: CGFloat) -> UIImage? {
        precondition(aspectRatio > 0.0)
        precondition(scale > 0.0)
        
        guard let image = CIImage(contentsOf: url) else { return nil }
        
        let filter = CIFilter(name: "CILanczosScaleTransform")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(scale, forKey: kCIInputScaleKey)
        filter?.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        
        guard
            let outputCIImage = filter?.outputImage,
            let outputCGImage = sharedContext.createCGImage(outputCIImage, from: outputCIImage.extent)
        else { return nil }
        
        return UIImage(cgImage: outputCGImage)
    }
}
