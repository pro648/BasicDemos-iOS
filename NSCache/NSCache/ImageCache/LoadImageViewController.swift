//
//  LoadImageViewController.swift
//  NSCache
//
//  Created by ad on 2023/1/23.
//

import UIKit

class LoadImageViewController: UIViewController {
    
    private let imgUrlStr = "https://raw.githubusercontent.com/pro648/tips/master/sources/images/21/CoreGraphics3-GroupedShadow.png"

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        if let cachedImage = ImageCache.shared.cache.object(forKey: imgUrlStr as NSString) {
            imageView.image = cachedImage
            print("The image is still cached")
            return
        } else {
            print("image went away")
        }
        
        guard
            let url = URL(string: imgUrlStr),
            let data = try? Data(contentsOf: url),
            let img = UIImage(data: data)
        else {
            return
        }
        
        imageView.image = img
        ImageCache.shared.cache.setObject(img, forKey: imgUrlStr as NSString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        view.backgroundColor = .yellow
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
