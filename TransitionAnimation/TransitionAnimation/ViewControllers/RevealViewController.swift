//
//  RevealViewController.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/25.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController {
    
    var petCard: PetCard?
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let dismissButton = UIButton(type: .system)
    
    var swipeInteractionController: SwipeInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        titleLabel.text = petCard?.name
        imageView.image = petCard?.image
        
        swipeInteractionController = SwipeInteractionController(viewController: self)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        
        dismissButton.setTitle("Start Over", for: .normal)
        dismissButton.addTarget(self, action: #selector(self.dismissPressed(_:)), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/4).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/4).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc private func dismissPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
