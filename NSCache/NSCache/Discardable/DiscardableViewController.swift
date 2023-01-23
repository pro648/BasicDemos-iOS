//
//  DiscardableViewController.swift
//  NSCache
//
//  Created by ad on 2023/1/23.
//

import UIKit

class DiscardableViewController: UIViewController {
    
    let personCache = NSCache<NSString, Person>()

    override func viewDidLoad() {
        super.viewDidLoad()

        personCache.name = "PersonCache"
        personCache.evictsObjectsWithDiscardedContent = false
        personCache.delegate = self
        
        let andy = Person(firstName: "Andy", lastName: "Ibanez", avatar: UIImage(named: "abc"))
        personCache.setObject(andy, forKey: "me")
    }
    
}

extension DiscardableViewController: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard let person = obj as? Person else {
            return
        }
        
        print("willEvictObject: \(person.firstName)")
    }
}
