//
//  ImageIO.swift
//  ImageResizing
//
//  Created by ad on 2022/1/15.
//

import Foundation
import UIKit
import MobileCoreServices

enum ImageIO {
    static func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        precondition(size != .zero)
        
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        
        guard
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else { return nil }
        
        return UIImage(cgImage: image)
    }
    
    static func resizedImageWithHintingAndSubsampling(at url: URL, for size: CGSize) -> UIImage? {
        precondition(size != .zero)
        
        guard
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
            let imageWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat,
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat
        else {
            return nil
        }
        
        var options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height),
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, url.pathExtension as CFString, kUTTypeImage)?.takeRetainedValue() {
            options[kCGImageSourceTypeIdentifierHint] = uti
            
            if uti == kUTTypeJPEG || uti == kUTTypeTIFF || uti == kUTTypePNG || String(uti).hasPrefix("public.heif") {
                switch min(imageWidth / size.width, imageHeight / size.height) {
                case ...2.0:
                    options[kCGImageSourceSubsampleFactor] = 2.0
                case 2.0...4.0:
                    options[kCGImageSourceSubsampleFactor] = 4.0
                case 4.0...:
                    options[kCGImageSourceSubsampleFactor] = 8.0
                default:
                    break
                }
            }
        }
        
        guard let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else { return nil }
        
        return UIImage(cgImage: image)
    }
}
