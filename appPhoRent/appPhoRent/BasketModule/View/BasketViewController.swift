//
//  BasketViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 10.05.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController {
    var presenter: BasketPresenterProtocol!
    
    var customIdentifier = "BasketTableViewCell"
    
    var indicatorView: UIActivityIndicatorView!
    
    var tableView: UITableView!
    var totalLabel: UILabel!
    var orderButton: UIButton!
    
    var dateLabel: UILabel!
    var changeDateButton: UIButton!
    var datePicker: UIDatePicker?
    
    
    var countDayLabel: UILabel!
    var dayStepper: UIStepper!
    
    let countDayString = "Количество дней аренды: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Корзина"
        setupUI()
        createConstraints()
        
        presenter.prepareData()
    }
    
    @objc func orderAction(_ sender: Any) {
        presenter.putOrder()
    }
    
    @objc func changeDateAction(_ sender: Any) {
        
        if let _ = datePicker {
            removeDatePicker()
        } else {
            totalLabel.isHidden = true
            orderButton.isHidden = true
            dayStepper.isHidden = true
            countDayLabel.isHidden = true
            datePicker = UIDatePicker()
            if let picker = datePicker {
                picker.datePickerMode = UIDatePicker.Mode.date
                picker.minimumDate = presenter.getDate()
                
                picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
                view.addGestureRecognizer(tapGesture)
                // picker.backgroundColor = UIColor.blackColor()
                self.view.addSubview(picker)
                picker.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constraints.bottom),
                    picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    picker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
                ])
            }
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        presenter.updateDate(newDate: sender.date)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        changeDateAction(sender)
    }
    
    private func removeDatePicker() {
        for gestureRecognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(gestureRecognizer)
        }
        datePicker?.removeFromSuperview()
        datePicker = nil
        totalLabel.isHidden = false
        orderButton.isHidden = false
        dayStepper.isHidden = false
        countDayLabel.isHidden = false
    }
    
    @objc func stepperChanged(_ sender: UIStepper) {
        countDayLabel.text = countDayString + Int(sender.value).description
        presenter.updateCountOfDay(newCount: Int(sender.value))
    }
}


// MARK: - BasketTableViewCellDelegate

extension BasketViewController: BasketTableViewCellDelegate {
    
    func deleteRow(sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: ((sender.superview?.superview) as! BasketTableViewCell)) {
            presenter.removeFromBasket(index: indexPath.row)
        }
    }
}


// MARK: - UI

extension BasketViewController {
    private func setupUI() {
        view.backgroundColor = CustomColors.background
        
        tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = CustomColors.background
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: customIdentifier, bundle: nil), forCellReuseIdentifier: customIdentifier)
        tableView.allowsSelection = false
        
        dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.textColor = CustomColors.textLabel
        dateLabel.backgroundColor = CustomColors.backgroundButton
        
        changeDateButton = UIButton(type: .system)
        changeDateButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        changeDateButton.backgroundColor = CustomColors.background
        changeDateButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0)
        changeDateButton.addTarget(self, action: #selector(changeDateAction), for: .touchUpInside)
        
        totalLabel = UILabel()
        totalLabel.text = "Итого: "
        totalLabel.textColor = CustomColors.textLabel
        totalLabel.backgroundColor = CustomColors.backgroundButton
        
        orderButton = UIButton(type: .system)
        orderButton.setTitle("Оформить заказ", for: .normal)
        orderButton.setTitleColor(CustomColors.textLabel, for: .normal)
        orderButton.backgroundColor = CustomColors.backgroundButton
        orderButton.addTarget(self, action: #selector(orderAction), for: .touchUpInside)
        
        countDayLabel = UILabel()
        countDayLabel.text = countDayString + "1"
        countDayLabel.textColor = CustomColors.textLabel
        countDayLabel.backgroundColor = CustomColors.backgroundButton
        
        dayStepper = UIStepper()
        dayStepper.minimumValue = 1
        dayStepper.maximumValue = 30
        dayStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        
        [tableView,
         totalLabel,
         orderButton,
         changeDateButton,
         dateLabel,
         countDayLabel,
         dayStepper].forEach { view.addSubview($0) }
    }
    
    private func createConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        changeDateButton.translatesAutoresizingMaskIntoConstraints = false
        
        countDayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayStepper.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: Constraints.bottom),
            
            orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constraints.bottom),
            orderButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderButton.heightAnchor.constraint(equalToConstant: 50),
            
            totalLabel.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: Constraints.bottom),
            totalLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalLabel.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.bottomAnchor.constraint(equalTo: countDayLabel.topAnchor, constant: Constraints.bottom),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            
            changeDateButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            changeDateButton.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            changeDateButton.widthAnchor.constraint(equalToConstant: 66),
            changeDateButton.heightAnchor.constraint(equalToConstant: 66),
            
            
            countDayLabel.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: Constraints.bottom),
            countDayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            countDayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            countDayLabel.heightAnchor.constraint(equalToConstant: 50),
            
            dayStepper.centerYAnchor.constraint(equalTo: countDayLabel.centerYAnchor),
            dayStepper.trailingAnchor.constraint(equalTo: countDayLabel.trailingAnchor, constant: Constraints.trailing)
        ])
    }
}

// MARK: - BasketViewProtocol

extension BasketViewController: BasketViewProtocol {
    func updateDateLabel(newDate: String) {
        dateLabel.text = "Дата начала аренды: \(newDate)"
    }
    
    func updateTotal(newTotalCost: Int) {
        totalLabel.text = "Итого: " + String(newTotalCost) + " руб."
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    
    //    func success(totalCost: Int, date: Date) {
    //        totalLabel.text = "Итого: " + String(totalCost)
    //        tableView.reloadData()
    //    }
    //
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showAlert() {
        
        print("showAlert")
        let alert = UIAlertController(title: nil, message: "Загрузка...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)
    }
    
    func closeAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearData() {
        countDayLabel.text = countDayString + "1"
        presenter.updateDate(newDate: Date())
    }
}

// MARK: - UITableViewDelegate

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: customIdentifier, for: indexPath)
        
        if let customTableViewCell = tableViewCell as? BasketTableViewCell {
            customTableViewCell.delegate = self
            let (name, cost, count, imageURL) = presenter.getItem(at: indexPath.row)
            customTableViewCell.fillCell(name: name, cost: cost, count: count, imageURL: imageURL)
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRow()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}
