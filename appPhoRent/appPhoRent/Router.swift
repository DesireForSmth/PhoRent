//
//  Router.swift
//  appPhoRent
//
//  Created by Александр Сетров on 05.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showLogin()
    func showSignUp()
    func popToRoot()
    func showContent()
    func showAboutUs()
    func showPasswordDrop()
    func showCategoryPage(categoryName: String)
    func logOut()
}

class Router: RouterProtocol {
    
    var sceneDelegate: SceneDelegateProtocol?
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    //var tabBarController: TabBarController?
    
    init (navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol/*, tabBarController: TabBarController*/, sceneDelegate: SceneDelegateProtocol){
        //self.tabBarController = tabBarController
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.sceneDelegate = sceneDelegate
    }
    
    
    
   
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let introViewController = assemblyBuilder?.createIntroModule(router: self) else { return }
            navigationController.viewControllers = [introViewController]
        }
    }
    
    func showLogin() {
        if let navigationController = navigationController {
            guard let loginViewController = assemblyBuilder?.createLoginModule(router: self) else { return }
            navigationController.pushViewController(loginViewController, animated: true)
        }
    }
    
    func showSignUp() {
        if let navigationController = navigationController {
            guard let signUpViewController = assemblyBuilder?.createSignUpModule(router: self) else { return }
            navigationController.pushViewController(signUpViewController, animated: true)
        }
    }
    
    func logOut() {
        destroyInitialModule()
        navigationController = UINavigationController()
        guard let introViewController = assemblyBuilder?.createIntroModule(router: self) else { return }
        sceneDelegate?.changeRootViewController(controller: navigationController!)
        navigationController?.pushViewController(introViewController, animated: true)
    }
    
    func destroyInitialModule() {
           self.navigationController = nil
       }
    
    func showContent(){
        destroyInitialModule()
        self.sceneDelegate?.openContent()
        /*
        guard let contenViewController = assemblyBuilder?.createContentModule(router: self) else {
            return
        }
        //navigationController = UINavigationController(rootViewController: contenViewController)
        self.sceneDelegate?.changeRootViewController(controller: contenViewController)
 */
    }
    
    func showAboutUs() {
        if let navigationController = navigationController {
            guard let aboutUsViewController = assemblyBuilder?.createAboutUsModule(router: self) else { return }
            navigationController.present(aboutUsViewController, animated: true, completion: nil)
        }
    }
    
    func showPasswordDrop() {
        if let navigationController = navigationController {
            guard let passwordDropViewController = assemblyBuilder?.createPasswordDropModule(router: self) else { return }
            navigationController.pushViewController(passwordDropViewController, animated: true)
        }
    }
    
    func showCategoryPage(categoryName: String) {
        if let navigationController = navigationController {
            guard let categoryViewController = assemblyBuilder?.createCategoryModule(router: self, categoryName: categoryName) else { return }
            navigationController.pushViewController(categoryViewController, animated: false)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
