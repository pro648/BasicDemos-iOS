//
//  MapPin.swift
//  MVVMPattern
//
//  Created by pro648 on 2019/7/9.
//  Copyright © 2019 pro648. All rights reserved.
//

import UIKit
import MapKit

public class BusinessMapViewModel: NSObject {
    
    // MARK: - Properties
    public let coordinate: CLLocationCoordinate2D
    public let name: String
    public let rating: Double
    public let image: UIImage
    public let ratingDescription: String
    
    // MARK: - Object Lifecycle
    public init(coordinate: CLLocationCoordinate2D,
                         name: String,
                         rating: Double,
                         image: UIImage) {
        self.coordinate = coordinate
        self.name = name
        self.rating = rating
        self.image = image
        self.ratingDescription = "\(rating) stars"
    }
}

// MARK: - MKAnnotation
extension BusinessMapViewModel: MKAnnotation {
    
    public var title: String? {
        return name;
    }
    
    public var subtitle: String? {
        return ratingDescription
    }
}
