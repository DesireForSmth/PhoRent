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
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        let firstAssemblyBuilder = AssemblyModuleBuilder()
        
        
        let firstRouter = Router(navigationController: firstNavigationController, assemblyBuilder: firstAssemblyBuilder, sceneDelegate: self.presenter.getScene())
        let firstPresenterVC = PersonalPresenter(view: firstViewController, router: firstRouter, networkService: networkSevice)
        firstViewController.presenter = firstPresenterVC
        
        let secondViewController = MainSearchViewController()
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        let secondAssemblyBuilder = AssemblyModuleBuilder()
        let secondRouter = Router(navigationController: secondNavigationController, assemblyBuilder: secondAssemblyBuilder, sceneDelegate: self.presenter.getScene())
        let secondPresenterVC = MainSearchPresenter(view: secondViewController, router: secondRouter, networkService: networkSevice)
        secondViewController.presenter = secondPresenterVC
        
        let thirdViewController = BasketViewController()
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)
        let thirdAssemblyBuilder = AssemblyModuleBuilder()
        let thirdRouter = Router(navigationController: thirdNavigationController, assemblyBuilder: thirdAssemblyBuilder, sceneDelegate: self.presenter.getScene())
        let thirdPresenterVC = BasketPresenter(view: thirdViewController, router: thirdRouter, networkService: networkSevice)
        thirdViewController.presenter = thirdPresenterVC
        
        firstNavigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        secondNavigationController.tabBarItem = UITabBarItem(title: "Поиск", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        thirdNavigationController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "cart.fill"), selectedImage: UIImage(systemName: "cart.fill"))
        
        let tabBarList = [firstNavigationController, secondNavigationController, thirdNavigationController]
        
        viewControllers = tabBarList
        selectedIndex = 1
    }
}

extension TabBarController: TabBarViewProtocol {
    
}
