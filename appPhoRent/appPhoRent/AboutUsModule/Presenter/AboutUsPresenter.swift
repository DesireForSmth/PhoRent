//
//  AboutUsPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

protocol AboutUsViewProtocol: class {
    
}


protocol AboutUsPresenterProtocol: class {
    init(view: AboutUsViewProtocol, router: RouterProtocol)
}


class AboutUsPresenter: AboutUsPresenterProtocol {
    
    weak var view: AboutUsViewProtocol?
    var router: RouterProtocol?
    
    required init(view: AboutUsViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
