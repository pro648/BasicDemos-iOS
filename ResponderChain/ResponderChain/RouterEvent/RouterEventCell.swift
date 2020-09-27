//
//  RouterEventCell.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/27.
//  

import UIKit

class RouterEventCell: UITableViewCell {
    
    lazy var firstButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("First", for: .normal)
        button.sizeToFit()
        return button
    }()
    
    lazy var secondButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Second", for: .normal)
        button.sizeToFit()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        firstButton.addTarget(self, action: #selector(self.firstButtonTapped(_:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(self.secondButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(firstButton)
        contentView.addSubview(secondButton)
        
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -40).isActive = true
        firstButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 40).isActive = true
        secondButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Cell 按钮的点击事件
    @objc private func firstButtonTapped(_: UIButton) {
        print(NSStringFromClass(type(of: self)) + "  " + #function)
        
        // 路由给控制器处理
        routerEvent(with: "firstButton", userInfo: [:])
    }
    
    @objc private func secondButtonTapped(_: UIButton) {
        print(NSStringFromClass(type(of: self)) + "  " + #function)
        
        routerEvent(with: "secondButton", userInfo: [:])
    }
}
