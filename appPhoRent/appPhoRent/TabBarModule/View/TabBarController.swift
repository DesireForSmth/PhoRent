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
    let networkSevice = NetworkService()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let firstViewController = PersonalViewController()
        let firstPresenterVC = PersonalPresenter(view: firstViewController, router: self.presenter.router!)
        firstViewController.presenter = firstPresenterVC
        firstViewController.view.backgroundColor = .white
        
        let secondViewController = MainSearchViewController()
        let secondPresenterVC = MainSearchPresenter(view: secondViewController, router: self.presenter.router!, networkService: networkSevice)
        secondViewController.presenter = secondPresenterVC
        secondViewController.view.backgroundColor = .blue
        
        let thirdViewController = UIViewController()
        
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        
        viewControllers = tabBarList
    }
}

extension TabBarController: TabBarViewProtocol {
}
