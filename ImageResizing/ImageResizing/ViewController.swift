//
//  ViewController.swift
//  ImageResizing
//
//  Created by ad on 2022/1/15.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/%E5%9B%BE%E5%83%8F%E4%B8%8B%E9%87%87%E6%A0%B7.md

import UIKit
import func AVFoundation.AVMakeRect

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loadPhotoButtonTapped(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "visibleEarth", withExtension: "jpg") else { return }
        
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let size = imageView.bounds.size.applying(scale)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let startTime = CACurrentMediaTime()
            
//            let image = UIImage(contentsOfFile: url.path)
            let image = UIKit.resizedImage(at: url, for: size)
//            let image = CoreGraphics.resizedImage(at: url, for: size)
//            let image = ImageIO.resizedImage(at: url, for: size)
//            let image = ImageIO.resizedImageWithHintingAndSubsampling(at: url, for: size)
//            let image = CoreImage.resizedImage(at: url, for: size)
//            let image = vImage.resizedImage(at: url, for: size)
            
            DispatchQueue.main.sync {
                let duration = 1.0
                UIView.transition(with: self.imageView, duration: duration, options: [.curveEaseOut, .transitionCrossDissolve]) {
                    self.imageView.image = image
                } completion: { _ in
                    let endTime = CACurrentMediaTime()
                    print("time: \(endTime - startTime - duration)")
                }
            }
        }
    }
}
