//
//  ViewController.swift
//  CoreGraphics-1
//
//  Created by ad on 2021/9/3.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/CoreGraphics%E7%B3%BB%E5%88%97%E4%B8%80%EF%BC%9Apath.md

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addAllSubviews()
        makeAllConstraints()
        updateAppearance()
    }

    private lazy var addButton: PushButton = {
        let button = PushButton()
        button.fillColor = UIColor(red: 87.0 / 255.0, green: 218.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(pushButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        let button = PushButton()
        button.isAddButton = false
        button.fillColor = UIColor(red: 238.0 / 255.0, green: 77.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(pushButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var counterView: CounterView = {
        let view = CounterView()
        view.backgroundColor = .white
        return view
    }()
}

extension ViewController {
    private func addAllSubviews() {
        view.addSubview(addButton)
        view.addSubview(minusButton)
        view.addSubview(counterView)
    }
    
    private func makeAllConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 100),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
        ])
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 50),
            minusButton.heightAnchor.constraint(equalToConstant: 50),
            minusButton.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            minusButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20)
        ])
        
        counterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            counterView.widthAnchor.constraint(equalToConstant: 230),
            counterView.heightAnchor.constraint(equalToConstant: 230),
            counterView.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: counterView.bottomAnchor, constant: 40),
        ])
    }
    
    private func updateAppearance() {
        counterView.counterLabel.text = String(counterView.counter)
    }
    
    @objc private func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        
        counterView.counterLabel.text = String(counterView.counter)
    }
}
