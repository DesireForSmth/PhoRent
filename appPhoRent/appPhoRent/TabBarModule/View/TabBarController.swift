//
//  TabBarController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var presenter: TabBarPresenterProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//        let centerNavigationController = UINavigationController(rootViewController: centerViewController)
//        view.addSubview(centerNavigationController.view)
//        addChild(centerNavigationController)
//
//        centerNavigationController.didMove(toParent: self)
        
        
        
        
        let firstViewController = PersonalViewController()
        let presenterVC = PersonalPresenter(view: firstViewController, router: self.presenter.router!)
        firstViewController.presenter = presenterVC
        firstViewController.view.backgroundColor = .white
        
        let secondViewController = UIViewController()
        
        let thirdViewController = BasketViewController()
        thirdViewController.navigationController?.setNavigationBarHidden(false, animated: true)
        let presenterThird = BasketPresenter(view: thirdViewController, router: self.presenter.router!)
        thirdViewController.presenter = presenterThird
        thirdViewController.view.backgroundColor = .lightGray
        
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        viewControllers = tabBarList
    }
}

extension TabBarController: TabBarViewProtocol {
}
