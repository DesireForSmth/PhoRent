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
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init (navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol){
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
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
    
    func showContent(){
        if let navigationController = navigationController {
            guard let contentViewController = assemblyBuilder?.createContentModule(router: self) else { return }
            navigationController.pushViewController(contentViewController, animated: true)
        }
    }
    
    func showAboutUs() {
        if let navigationController = navigationController {
            guard let aboutUsViewController = assemblyBuilder?.createAboutUsModule(router: self) else { return }
            navigationController.present(aboutUsViewController, animated: true, completion: nil)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
