//
//  CategoryViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryViewController: UIViewController {

    var presenter: CategoryViewPresenterProtocol!
    
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.register(UINib(nibName: "ItemCellViewController", bundle: nil), forCellReuseIdentifier: "itemCell")
        tableView.rowHeight = 80
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        self.navigationBar.topItem?.title = presenter.getCategoryName()
        
        self.navigationController?.isNavigationBarHidden = true
        print("hallo")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.presenter.pop()
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
        print("success")
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        
    }
    
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(presenter.items?.count)
        return presenter.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCellViewController
        let itemName = presenter.items?[indexPath.item].name
        let itemImage = presenter.items?[indexPath.item].imageURL
        let itemCost = presenter.items?[indexPath.item].cost
        cell.itemName.text = itemName
        cell.itemCost.text = itemCost
        let url = URL(string: itemImage!)
        let resource = ImageResource(downloadURL: url!, cacheKey: itemImage)
        cell.itemImage.kf.setImage(with: resource)
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCellViewController
        let itemName = presenter.items?[indexPath.item].name
        let itemImage = presenter.items?[indexPath.item].imageURL
        let itemCost = presenter.items?[indexPath.item].cost
        cell.itemName.text = itemName
        cell.itemCost.text = itemCost
        let url = URL(string: itemImage!)
        let resource = ImageResource(downloadURL: url!, cacheKey: itemImage)
        cell.itemImage.kf.setImage(with: resource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {/*
        if let cell: MainSearchTableViewCell = tableView.cellForRow(at: indexPath) as? MainSearchTableViewCell {
            if let categoryName = cell.categoryName.text {
                self.presenter.cellPicked(categoryName: categoryName)
            }
        }*/
    }
    */
}

