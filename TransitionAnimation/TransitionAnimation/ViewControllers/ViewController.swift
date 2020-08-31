//
//  ViewController.swift
//  TransitionAnimation
//
//  Created by pro648 on 2020/8/25.
//  Copyright © 2020 pro648. All rights reserved.
//
//  详细介绍：https://github.com/pro648/tips/blob/master/sources/%E8%87%AA%E5%AE%9A%E4%B9%89%E8%A7%86%E5%9B%BE%E6%8E%A7%E5%88%B6%E5%99%A8%E8%BD%AC%E5%9C%BA%E5%8A%A8%E7%94%BB.md

import UIKit

class ViewController: UIViewController {
    
    private let petCards = PetCardStore.defaultPets
    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing : 20])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.black
        let cardVC = viewControllerForPage(at: 0)
        pageViewController.setViewControllers([cardVC], direction: .forward, animated: false, completion: nil)
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
}

extension ViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? CardViewController,
            let pageIndex = vc.pageIndex,
        pageIndex > 0 else { return nil }
        
        return viewControllerForPage(at: pageIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? CardViewController,
            let pageIndex = vc.pageIndex,
            pageIndex + 1 < petCards.count else { return nil }
        
        return viewControllerForPage(at: pageIndex + 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return petCards.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewControllers = pageViewController.viewControllers,
            let currentVC = viewControllers.first as? CardViewController,
            let currentPageIndex = currentVC.pageIndex else { return 0 }
        
        return currentPageIndex
    }
    
    private func viewControllerForPage(at index: Int) -> UIViewController {
        let cardVC = CardViewController()
        cardVC.pageIndex = index
        cardVC.petCard = petCards[index]
        return cardVC
    }
}
