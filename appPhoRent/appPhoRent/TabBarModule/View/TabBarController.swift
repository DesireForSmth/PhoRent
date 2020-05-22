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
        /*
        let firstViewController = PersonalViewController()
        let firstNavController = UINavigationController(rootViewController: firstViewController)
        let firstPresenterVC = PersonalPresenter(view: firstViewController, router: self.presenter.router1!)
        firstViewController.presenter = firstPresenterVC
        
        let secondViewController = PersonalViewController()
        let secondNavController = UINavigationController(rootViewController: secondViewController)
        let secondPresenterVC = PersonalPresenter(view: secondViewController, router: self.presenter.router1!)
        secondViewController.presenter = secondPresenterVC
        */
        
        /*
        let firstViewController = PersonalViewController()
        //let firstNavController = UINavigationController(rootViewController: firstViewController)
        let firstPresenterVC = PersonalPresenter(view: firstViewController, router: self.presenter.router!)
        firstViewController.presenter = firstPresenterVC
        firstViewController.view.backgroundColor = .white
        
        let secondViewController = MainSearchViewController()
        let secondPresenterVC = MainSearchPresenter(view: secondViewController, router: self.presenter.router!, networkService: networkSevice)
        secondViewController.presenter = secondPresenterVC
        secondViewController.view.backgroundColor = .blue
        
        let thirdViewController = UIViewController()
        */
        
        
        let firstViewController = PersonalViewController()
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        let firstAssemblyBuilder = AssemblyModuleBuilder()
        print(firstNavigationController)
        print(firstViewController)
        print(self.presenter.getScene())
        
        
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
        secondNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        thirdNavigationController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "cart.fill"), selectedImage: UIImage(systemName: "cart.fill"))
        
        let tabBarList = [firstNavigationController, secondNavigationController, thirdNavigationController]
        
        viewControllers = tabBarList
        selectedIndex = 1
    }
}

extension TabBarController: TabBarViewProtocol {
    
}
