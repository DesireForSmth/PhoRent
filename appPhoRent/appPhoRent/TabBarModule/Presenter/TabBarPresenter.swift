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
    init(view: TabBarViewProtocol, router: RouterProtocol)
    var router: RouterProtocol? {get set}
}


class TabBarPresenter: TabBarPresenterProtocol {
    weak var view: TabBarViewProtocol?
    var router: RouterProtocol?

    required init(view: TabBarViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
