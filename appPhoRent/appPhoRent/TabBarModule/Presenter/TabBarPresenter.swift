//
//  TabBarPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

protocol TabBarViewProtocol: class {
    
}

protocol TabBarPresenterProtocol: class {
    init(view: TabBarViewProtocol, scene: SceneDelegateProtocol/*, router: RouterProtocol*/)
    func getScene() -> SceneDelegateProtocol
    //var router1: RouterProtocol? {get set}
    //var router2: RouterProtocol? {get set}
    //var router3: RouterProtocol? {get set}
    //var router: RouterProtocol? {get set}
}


class TabBarPresenter: TabBarPresenterProtocol {
    
    weak var scene: SceneDelegateProtocol?
    
    //var router1: RouterProtocol?
    
    //var router2: RouterProtocol?
    
    //var router3: RouterProtocol?
    
    //var router: RouterProtocol?
    
    weak var view: TabBarViewProtocol?

    func getScene() -> SceneDelegateProtocol {
        return self.scene as! SceneDelegateProtocol
    }
    
    required init(view: TabBarViewProtocol, scene: SceneDelegateProtocol/*, router: RouterProtocol*/) {
        print(scene)
        self.view = view
        self.scene = scene
        //self.router = router
    }
}
