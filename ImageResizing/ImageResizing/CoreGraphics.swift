//
//  CoreGraphics.swift
//  ImageResizing
//
//  Created by ad on 2022/1/15.
//

import CoreGraphics
import Foundation
import UIKit

enum CoreGraphics {
    static func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        precondition(size != .zero)
        
        guard
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else { return nil }
        
        let context = CGContext(data: nil,
                                width: Int(size.width), height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect(origin: .zero, size: size))
        
        guard let scaledImage = context?.makeImage() else { return nil }
        
        return UIImage(cgImage: scaledImage)
    }
}
