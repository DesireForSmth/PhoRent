//
//  ModuleBuilder.swift
//  appPhoRent
//
//  Created by Александр Сетров on 31.03.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    func createIntroModule(router: RouterProtocol) -> UIViewController
    func createLoginModule(router: RouterProtocol) -> UIViewController
    func createContentModule(router: RouterProtocol) -> UIViewController
    func createSignUpModule(router: RouterProtocol) -> UIViewController
    func createPasswordDropModule(router: RouterProtocol) -> UIViewController
    func createAboutUsModule(router: RouterProtocol) -> UIViewController
    func createCategoryModule(router: RouterProtocol, category: Category) -> UIViewController
    //func createFiltersModule(router: RouterProtocol, category: Category, networkService: NetworkService) -> UIViewController
    //func createAuthModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    /*
    func createFiltersModule(router: RouterProtocol, category: Category, networkService: NetworkService) -> UIViewController {
        let view = FiltersViewController()
        let presenter = CategoryPresenter(view: view, router: router, category: category, networkService: networkService)
        
    }
    */
    
    func createCategoryModule(router: RouterProtocol, category: Category) -> UIViewController {
        let networkService = NetworkService()
        let view = CategoryViewController()
        let presenter = CategoryPresenter(view: view, router: router, category: category, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createSignUpModule(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = SignUpViewController()
        let presenter = SignUpPresenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createIntroModule(router: RouterProtocol) -> UIViewController {
        let view = IntroViewController()
        let networkService = NetworkService()
        let presenter = IntroPresenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    func createLoginModule(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = LoginViewController()
        let presenter = LoginPresenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createContentModule(router: RouterProtocol) -> UIViewController {
        
        
        
        
        let view = TabBarController()



        //let presenter = TabBarPresenter(view: view, router: router)
        //view.presenter = presenter
        return view
        //           let view = ContentViewController()
        //           let presenter = ContentPresenter(view: view, router: router)
        //           view.presenter = presenter
        //           return view
    }
    
    func createAboutUsModule(router: RouterProtocol) -> UIViewController {
        let view = AboutUsViewController()
        let networkService = NetworkService()
        let presenter = AboutUsPresenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    func createPasswordDropModule(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = PasswordDropViewController()
        let presenter = PasswordDropPresenter(view: view, router: router, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    /*
     func createAuthModule(router: RouterProtocol) -> UIViewController {
     let view = NewAuthViewController()
     let presenter = AuthPresenter(view: view, router: router)
     view.presenter = presenter
     return view
     }
     */
}
