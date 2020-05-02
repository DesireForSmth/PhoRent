//
//  CategoryViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var presenter: CategoryViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        self.navigationController?.isNavigationBarHidden = true
        print("hallo")
        print(presenter.getCategory())
        // Do any additional setup after loading the view.
    }

    @IBAction func filtersTapped(_ sender: UIBarButtonItem) {
        self.presenter.filtersPicked()
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    /*
    @IBAction func filtersTapped(_ sender: UIBarButtonItem) {
        self.presenter.filtersPicked()
    }
    */
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                self.presenter.pop()
                default:
                    break
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoryViewController: CategoryViewProtocol {
    func success() {
        
    }
    
    func failure(error: Error) {
        
    }
    
    
}
