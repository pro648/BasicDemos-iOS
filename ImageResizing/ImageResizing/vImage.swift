//
//  vImage.swift
//  ImageResizing
//
//  Created by ad on 2022/1/15.
//

import Foundation
import Accelerate.vImage
import UIKit

enum vImage {
    static func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        precondition(size  != .zero)
        
        // Decode the source image
        guard
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let _ = properties[kCGImagePropertyPixelWidth] as? vImagePixelCount,
            let _ = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
        else {
            return nil
        }
        
        // Define the image format
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)
        var error: vImage_Error
        
        // Create and initialize the source buffer
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.deallocate()
        }
        
        error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, image, vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create and initizlize the destination buffer
        var destinationBuffer = vImage_Buffer()
        error = vImageBuffer_Init(&destinationBuffer,
                                  vImagePixelCount(size.height),
                                  vImagePixelCount(size.width),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil}
        
        // Scale the image
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     &destinationBuffer,
                                     nil,
                                     vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // Create a CGImage from the destination buffer
        guard
            let resizedImage = vImageCreateCGImageFromBuffer(&destinationBuffer,
                                                             &format,
                                                             nil,
                                                             nil,
                                                             vImage_Flags(kvImageNoAllocate),
                                                             &error)?.takeRetainedValue(),
            error == kvImageNoError
        else { return nil }
        
        return UIImage(cgImage: resizedImage)
    }
}
