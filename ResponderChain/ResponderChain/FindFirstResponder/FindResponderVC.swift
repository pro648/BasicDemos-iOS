//
//  FindResponderVC.swift
//  ResponderChain
//
//  Created by pro648 on 2020/9/25.
//  

import UIKit

/// 分析 hit-testing 查找 firstResponder 的流程
class FindResponderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        var nextResponder = viewB1.next
//        var responderStr = "---"
//        while (nextResponder != nil) {
//            print(responderStr + NSStringFromClass(type(of: nextResponder!)))
//            responderStr = responderStr.appending("----")
//            nextResponder = nextResponder?.next
//        }
//    }
    
    private func setupUI() {
        let subWidth = view.bounds.size.width / 5 * 3 - 20
        let subHeight = subWidth / 3 * 2
        
        viewA.frame = CGRect(x: 10, y: 100, width: subWidth + 20, height: subHeight * 2 + 40)
        viewA1.frame = CGRect(x: 10, y: 20, width: subWidth, height: subHeight)
        viewA2.frame = CGRect(x: 10, y: subHeight + 30, width: subWidth, height: subHeight)
        
        viewB.frame = CGRect(x: view.bounds.size.width - subWidth - 30, y: viewA.center.y + 30, width: subWidth + 20, height: subHeight * 2 + 40)
        viewB1.frame = CGRect(x: 10, y: 20, width: subWidth, height: subHeight)
        viewB2.frame = CGRect(x: 10, y: subHeight + 30, width: subWidth, height: subHeight)
        
        viewC.frame = CGRect(x: 10, y: viewB.frame.maxY + 10, width: view.bounds.size.width - 20, height: subHeight)
        viewC1.frame = CGRect(x: 10, y: 20, width: (viewC.bounds.size.width - 30) / 2, height: subHeight - 30)
        viewC2.frame = CGRect(x: viewC1.frame.maxX + 10, y: 20, width: viewC1.bounds.width, height: viewC1.bounds.size.height)
        
        view.addSubview(viewA)
        viewA.addSubview(viewA1)
        viewA.addSubview(viewA2)
        
        view.addSubview(viewB)
        viewB.addSubview(viewB1)
        viewB.addSubview(viewB2)
        
        view.addSubview(viewC)
        viewC.addSubview(viewC1)
        viewC.addSubview(viewC2)
    }
    
    lazy var viewA: ViewA = {
        let viewA = ViewA()
        viewA.backgroundColor = UIColor(red: 200.0/255.0, green: 136.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        return viewA
    }()
    lazy var viewA1: ViewA1 = {
        let viewA1 = ViewA1()
        viewA1.backgroundColor = UIColor(red: 173.0/255.0, green: 75.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        return viewA1
    }()
    lazy var viewA2: ViewA2 = {
        let viewA2 = ViewA2()
        viewA2.backgroundColor = UIColor(red: 173.0/255.0, green: 75.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        return viewA2
    }()
    
    lazy var viewB: ViewB = {
        let viewB = ViewB()
        viewB.backgroundColor = UIColor(red: 129.0/255.0, green: 198.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        return viewB
    }()
    lazy var viewB1: ViewB1 = {
        let viewB1 = ViewB1()
        viewB1.backgroundColor = UIColor(red: 68.0/255.0, green: 170.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        return viewB1
    }()
    lazy var viewB2: ViewB2 = {
        let viewB2 = ViewB2()
        viewB2.backgroundColor = UIColor(red: 68.0/255.0, green: 170.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        return viewB2
    }()
    
    lazy var viewC: ViewC = {
        let viewC = ViewC()
        viewC.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        return viewC
    }()
    lazy var viewC1: ViewC1 = {
        let viewC1 = ViewC1()
        viewC1.backgroundColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        return viewC1
    }()
    lazy var viewC2: ViewC2 = {
        let viewC2 = ViewC2()
        viewC2.backgroundColor = UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        return viewC2
    }()
}
