//
//  FiltersViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 14.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import RangeSeekSlider
import Kingfisher

class FiltersViewController: UIViewController {

    weak var presenter: CategoryViewPresenterProtocol!

    private var costLabel = UILabel()
    private var costRangeSlider = RangeSeekSlider()
    private var manufacturerLabel = UILabel()
    private var manufacturerTableView = UITableView()

    var manufacturersSet: Set<String>!
    var manufacturersArray: [String]!
    var manufacturersOutputSet: Set<String> = []
    
    
    private var closeBtn = UIButton()

    private var textLabel = UILabel()
    
    
    
    lazy var contentViewSize = CGSize(width: 300, height: 400)
    
    
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.frame = CGRect(x: 0, y: 0, width: self.contentViewSize.width, height: self.view.frame.height)
        view.contentSize = contentViewSize
        view.autoresizingMask = .flexibleHeight
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.bounces = true
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        return view
    }()
    
    
    var items: [Item]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: self.contentViewSize.width, height: self.contentViewSize.height)
        self.setupView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.manufacturersSet = presenter.manufacturers
        self.manufacturersArray = Array(self.manufacturersSet)
        isModalInPresentation = false
        manufacturerTableView.delegate = self
        manufacturerTableView.dataSource = self
        manufacturerTableView.register(UINib(nibName: "ManufacturerTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        manufacturerTableView.rowHeight = 64
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.presenter.setCostRange(minCost: self.costRangeSlider.selectedMinValue, maxCost: self.costRangeSlider.selectedMaxValue)
        self.presenter.closeFilters()
    }
    
    @objc func closeSelf() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension FiltersViewController {
    func setupView() {
        
        
        /*
        self.scrollView.addSubview(containerView)
        
        self.containerView.addSubview(closeBtn)
        
        self.closeBtn.translatesAutoresizingMaskIntoConstraints = false
        self.closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.closeBtn.addTarget(self, action: #selector(self.closeSelf), for: .touchUpInside)
        self.closeBtn.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10).isActive = true
        self.closeBtn.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10).isActive = true
        self.closeBtn.imageView?.contentMode = .scaleToFill
        self.closeBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.closeBtn.imageView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.closeBtn.imageView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.containerView.addSubview(textLabel)
        
        self.textLabel.text = "Фильтры"
        self.textLabel.font = UIFont.systemFont(ofSize: 17)
        
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -15).isActive = true
        self.textLabel.centerYAnchor.constraint(equalTo: self.closeBtn.centerYAnchor, constant: 0).isActive = true
        */
       
        self.view.addSubview(self.closeBtn)
        
        self.closeBtn.translatesAutoresizingMaskIntoConstraints = false
        self.closeBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.closeBtn.addTarget(self, action: #selector(self.closeSelf), for: .touchUpInside)
        self.closeBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.closeBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.closeBtn.imageView?.contentMode = .scaleToFill
        self.closeBtn.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.closeBtn.imageView?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.closeBtn.imageView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(textLabel)
        
        self.textLabel.text = "Фильтры"
        self.textLabel.font = UIFont.systemFont(ofSize: 17)
        
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.textLabel.centerYAnchor.constraint(equalTo: self.closeBtn.centerYAnchor, constant: 0).isActive = true
        
        self.view.addSubview(scrollView)
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.closeBtn.bottomAnchor, constant: 10).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.scrollView.addSubview(containerView)
        
        
        self.containerView.addSubview(costLabel)
        
        self.costLabel.text = "Цена:"
        
        self.costLabel.translatesAutoresizingMaskIntoConstraints = false
        self.costLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10).isActive = true
        self.costLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 10).isActive = true
        
        self.containerView.addSubview(costRangeSlider)
        
        self.costRangeSlider.translatesAutoresizingMaskIntoConstraints = false
        self.costRangeSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.costRangeSlider.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 20).isActive = true
        self.costRangeSlider.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -20).isActive = true
        self.costRangeSlider.topAnchor.constraint(equalTo: self.costLabel.bottomAnchor, constant: 20).isActive = true
        
        self.costRangeSlider.minValue = CGFloat(self.presenter.getMinCost()!)
        self.costRangeSlider.maxValue = CGFloat(self.presenter.getMaxCost()!)
        self.costRangeSlider.selectedMinValue = self.presenter.getMinCurCost() ?? self.costRangeSlider.minValue
        self.costRangeSlider.selectedMaxValue = self.presenter.getMaxCurCost() ?? self.costRangeSlider.maxValue
        
        self.containerView.addSubview(manufacturerLabel)
        
        self.manufacturerLabel.text = "Производитель:"
        self.manufacturerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.manufacturerLabel.topAnchor.constraint(equalTo: self.costRangeSlider.bottomAnchor, constant: 40).isActive = true
        self.manufacturerLabel.leftAnchor.constraint(equalTo: self.costLabel.leftAnchor, constant: 0).isActive = true
        
        self.containerView.addSubview(manufacturerTableView)
        self.manufacturerTableView.backgroundColor = .clear
        self.manufacturerTableView.translatesAutoresizingMaskIntoConstraints = false
        self.manufacturerTableView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0).isActive = true
        self.manufacturerTableView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: 0).isActive = true
        self.manufacturerTableView.topAnchor.constraint(equalTo: self.manufacturerLabel.bottomAnchor, constant: 20).isActive = true
        
        self.manufacturerTableView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
        
    }
}

extension FiltersViewController: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

extension FiltersViewController: UIViewControllerTransitioningDelegate {
    
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.manufacturers.count
        self.manufacturerLabel.isHidden = count == 0
        let contentSize = CGSize(width: 300, height: 400 + count * 64)
        self.scrollView.contentSize = contentSize
        self.containerView.frame.size = contentSize
        self.manufacturerTableView.heightAnchor.constraint(equalToConstant: CGFloat(count * 64)).isActive = true
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManufacturerTableViewCell
        
        let name = manufacturersArray[indexPath.item]
        cell.manufacturerNameLabel.text = name
        cell.presenter = self.presenter
        cell.reload()
        return cell
    }
}
