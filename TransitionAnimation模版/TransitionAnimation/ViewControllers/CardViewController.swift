//
//  CardViewController.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/25.
//  Copyright © 2020 pro648. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    static let cardCornerRadius: CGFloat = 25
    var pageIndex: Int?
    var petCard: PetCard?
    var cardView = UIView()
    var titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        titleLabel.text = petCard?.description
        cardView.layer.cornerRadius = CardViewController.cardCornerRadius
        cardView.layer.masksToBounds = true
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        cardView.backgroundColor = UIColor(red: 15.0/255.0, green: 112.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        cardView.addGestureRecognizer(tapGesture)
        view.addSubview(cardView)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        titleLabel.backgroundColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor(red: 15.0/255.0, green: 112.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        cardView.addSubview(titleLabel)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cardView.heightAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 4/3).isActive = true
        cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cardView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: cardView.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc private func handleTap() {
        let revealVC = RevealViewController()
        revealVC.petCard = petCard
        revealVC.modalPresentationStyle = .fullScreen
        present(revealVC, animated: true, completion: nil)
    }
}
