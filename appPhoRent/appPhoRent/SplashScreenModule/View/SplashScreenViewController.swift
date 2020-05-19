//
//  SplashScreenViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 14.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    var presenter: SplashScreenPresenter!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        firstLabel.layer.opacity = 0
        secondLabel.layer.opacity = 0
        thirdLabel.layer.opacity = 0
        fourthLabel.layer.opacity = 0

        mainLabel.font = .systemFont(ofSize: 50, weight: .semibold)
        mainLabel.transform = mainLabel.transform.scaledBy(x: 0.5, y: 0.5);

        UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations:  { [weak self] in
            self?.mainLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: { [weak self] in
            self?.firstLabel.layer.opacity = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: { [weak self] in
            self?.secondLabel.layer.opacity = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1.5, options: [], animations: { [weak self] in
            self?.thirdLabel.layer.opacity = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 2, options: [], animations: { [weak self] in
            self?.fourthLabel.layer.opacity = 1
        }, completion: { [weak self] done in
            self?.presenter.checkSignedIn()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.presenter.checkSignedIn()
    }
}

extension SplashScreenViewController: SplashScreenViewProtocol {
    func success() {
        presenter.openContent()
    }

    func failure() {
        presenter.openIntro()
    }
}


