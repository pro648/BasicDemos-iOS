//
//  UIKit.swift
//  ImageResizing
//
//  Created by ad on 2022/1/15.
//

import UIKit

enum UIKit {
    static func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
        guard let image = UIImage(contentsOfFile: url.path) else { return nil }
        
        var format: UIGraphicsImageRendererFormat
        if #available(iOS 11.0, *) {
            format = .preferred()
        } else {
            format = .default()
        }
        format.opaque = false
        format.scale = UIScreen.main.scale

        let renderer = UIGraphicsImageRenderer(size: size, format: format)                 
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
