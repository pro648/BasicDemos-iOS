//
//  PhotoCell.swift
//  Operation&OperationQueue
//
//  Created by pro648 on 2020/4/19.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

final class PhotoCell: UITableViewCell {
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool {
        get {
            return activityIndicator.isAnimating
        }
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func display(image: UIImage?) {
        imgView.image = image
    }
}
