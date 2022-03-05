//
//  AnimatedView.swift
//  ResponderChain
//
//  Created by ad on 2022/2/28.
//

import UIKit

class AnimatedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemRed
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTapGestureTapped(_:)))
        addGestureRecognizer(tapGesture)
        
        let propertyAnimator = UIViewPropertyAnimator(duration: 10, curve: .linear) {
            self.button.center = goal
        }
        propertyAnimator.startAnimation()
    }
    
    @objc private func handleSingleTapGestureTapped(_ sender: UITapGestureRecognizer) {
        print("\(#line) \(#function)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let presentationLayer = layer.presentation()
        let superPoint = convert(point, to: superview)
        guard let prespt = superview?.layer.convert(superPoint, to: presentationLayer) else {
            return super.hitTest(point, with: event)
        }

        let hitView = super.hitTest(prespt, with: event)
        return hitView
    }
}
