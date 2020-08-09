//
//  ImageIOViewController.swift
//  CoreAnimation
//
//  Created by pro648 on 2020/8/9.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：[图像IO之图片加载、解码，缓存](https://github.com/pro648/tips/blob/master/sources/%E5%9B%BE%E5%83%8FIO%E4%B9%8B%E5%9B%BE%E7%89%87%E5%8A%A0%E8%BD%BD%E3%80%81%E8%A7%A3%E7%A0%81%EF%BC%8C%E7%BC%93%E5%AD%98.md)

import UIKit

class ImageIOViewController: BaseViewController {
    
    let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = UIScreen.main.bounds.size
        return flowLayout
    }()
    var collectionView: UICollectionView?
    
    private let cellIdentifier = "cellIdentifier"
    var imagePaths = [String]()
    
    let cache = NSCache<CustomKey, AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePaths = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Vacation Photos")
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.dataSource = self
        view.addSubview(collectionView!)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension ImageIOViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    // 未优化性能版本
    /*
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        // Add image view
        let imageTag = 99
        var imageView = cell.viewWithTag(imageTag) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView!.tag = imageTag
            cell.contentView.addSubview(imageView!)
        }
        
        // Set image
        let imagePath = imagePaths[indexPath.item]
        imageView?.image = UIImage(contentsOfFile: imagePath)
        
        return cell
    }
 */
    
    /*
    // 使用GCD后台线程加载图片
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        // Add image view
        let imageTag = 99
        var imageView = cell.viewWithTag(imageTag) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView!.tag = imageTag
            cell.contentView.addSubview(imageView!)
        }
        
        // Tag cell with index and clear current image
        cell.tag = indexPath.row
        imageView?.image = nil
        
        // Switch to background thread
        DispatchQueue.global(qos: .utility).async {
            // Load image
            let idx = indexPath.item
            let imagePath = self.imagePaths[idx]
            let img = UIImage(contentsOfFile: imagePath)
            
            // Set image on main thread, but only if index still matches up
            DispatchQueue.main.async {
                if idx == cell.tag {
                    imageView?.image = img
                }
            }
        }
        
        return cell
    }
     */
    
    /*
    // 使用 ImageIO 框架解码
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        // Add image view
        let imageTag = 99
        var imageView = cell.viewWithTag(imageTag) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView!.tag = imageTag
            cell.contentView.addSubview(imageView!)
        }
        
        // Tag cell with index and clear current image
        cell.tag = indexPath.row
        imageView?.image = nil
        
        // Switch to background thread
        DispatchQueue.global(qos: .utility).async {
            // Load image
            let idx = indexPath.item
            let imageUrl = URL(fileURLWithPath: self.imagePaths[idx])
            
            let options = [kCGImageSourceShouldCache : true]
            let source = CGImageSourceCreateWithURL(imageUrl as CFURL, nil)
            var img = UIImage()
            if source != nil {
                let imageRef = CGImageSourceCreateImageAtIndex(source!, 0, options as CFDictionary)
                if imageRef != nil {
                    img = UIImage(cgImage: imageRef!)
                }
            }
            
            // Set image on main thread, but only if index still matches up
            DispatchQueue.main.async {
                if idx == cell.tag {
                    imageView?.image = img
                }
            }
        }
        
        return cell
    }
 */
    
    /*
    // 显示图片前在后台线程重绘
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        // Add image view
        let imageTag = 99
        var imageView = cell.viewWithTag(imageTag) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView!.tag = imageTag
            cell.contentView.addSubview(imageView!)
        }
        
        // Tag cell with index and clear current image
        cell.tag = indexPath.row
        imageView?.image = nil
        let imgSize = imageView?.bounds.size
        let imgBounds = imageView?.bounds
        
        // Switch to background thread
        DispatchQueue.global(qos: .utility).async {
            // Load image
            let idx = indexPath.item
            let imagePath = self.imagePaths[idx]
            var img = UIImage(contentsOfFile: imagePath)
            
            // Redraw image using device context
            UIGraphicsBeginImageContextWithOptions(imgSize ?? CGSize.zero, true, 0)
            img?.draw(in: imgBounds ?? CGRect.zero)
            img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Set image on main thread, but only if index still matches up
            DispatchQueue.main.async {
                if idx == cell.tag {
                    imageView?.image = img
                }
            }
        }
        
        return cell
    }
 */
    
    // 使用 NSCache 提前缓存图片
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        var imageView = cell.contentView.subviews.last as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView?.contentMode = .scaleAspectFit
            cell.contentView.addSubview(imageView!)
        }
        
        // Set or load iamge for this index
        imageView?.image = loadImage(at: indexPath.item)
        
        // Preload image for previous and next index.
        if indexPath.item < self.imagePaths.count - 1 {
            loadImage(at: indexPath.item + 1)
        }
        if indexPath.item > 0 {
            loadImage(at: indexPath.item - 1)
        }
        
        return cell
    }
    
    @discardableResult
    func loadImage(at index: Int) -> UIImage? {
        let image: UIImage? = cache.object(forKey: CustomKey(int: index, string: String(index))) as? UIImage
        
        if image != nil {
            if image!.isKind(of: NSNull.self) {
                return nil
            } else {
                return image
            }
        }
        
        // Set placeholder to avoid reloading image multiple times
        cache.setObject(NSNull.self, forKey: CustomKey(int: index, string: String(index)))
        
        // Switch to background thread
        DispatchQueue.global().async {
            // Load Image
            let imagePath = self.imagePaths[index]
            
            var image = UIImage(contentsOfFile: imagePath)
            
            // Redraw image using device context
            UIGraphicsBeginImageContextWithOptions(image?.size ?? CGSize.zero, true, 0)
            image?.draw(at: CGPoint.zero)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Set image for correct image view
            DispatchQueue.main.async {
                self.cache.setObject(image ?? NSNull.self, forKey: CustomKey(int: index, string: String(index)))
                
                // Display the image
                let indexPath = NSIndexPath(item: index, section: 0) as IndexPath
                let cell = self.collectionView?.cellForItem(at: indexPath)
                
                let imageView = cell?.contentView.subviews.last as? UIImageView
                imageView?.image = image
            }
        }
        
        return nil
    }
}

final class CustomKey : NSObject {
    
    let int: Int
    let string: String
    
    init(int: Int, string: String) {
        self.int = int
        self.string = string
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? CustomKey else {
            return false
        }
        return int == other.int && string == other.string
    }
    
    override var hash: Int {
        return int.hashValue ^ string.hashValue
    }
    
}
