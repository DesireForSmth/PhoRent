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
    
    var emptyLabel: UILabel!
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
                picker.minimumDate = Date()
                picker.setDate(presenter.getDate(), animated: false)
                
                picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
                view.addGestureRecognizer(tapGesture)
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
            let alert = UIAlertController(title: nil, message: "Удалить товар из корзины?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { [weak self]
            _ in
                self?.presenter.removeFromBasket(index: indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
//            presenter.removeFromBasket(index: indexPath.row)
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
        
        dateLabel = LabelWithInsets()
        dateLabel.textColor = CustomColors.textLabel
        dateLabel.backgroundColor = CustomColors.backgroundLabel
        
        emptyLabel = UILabel()
        emptyLabel.text = "В корзине пусто"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = CustomColors.textLabel
        emptyLabel.backgroundColor = CustomColors.background
        
        changeDateButton = UIButton(type: .system)
        changeDateButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        changeDateButton.tintColor = CustomColors.backgroundButton
        changeDateButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0)
        changeDateButton.addTarget(self, action: #selector(changeDateAction), for: .touchUpInside)
        
        totalLabel = UILabel()
        totalLabel.text = "Итого: "
        totalLabel.textAlignment = .center
        totalLabel.textColor = CustomColors.textLabel
        totalLabel.backgroundColor = CustomColors.backgroundLabel
        
        orderButton = UIButton(type: .system)
        orderButton.setTitle("Оформить заказ", for: .normal)
        orderButton.setTitleColor(CustomColors.textButton, for: .normal)
        
        orderButton.layer.cornerRadius = 25
        orderButton.backgroundColor = CustomColors.backgroundButton
        
        orderButton.layer.shadowColor = UIColor.gray.cgColor
        orderButton.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        orderButton.layer.shadowOpacity = 1.0
        orderButton.layer.shadowRadius = 3.0
        orderButton.layer.masksToBounds = false
        
        orderButton.addTarget(self, action: #selector(orderAction), for: .touchUpInside)
        
        countDayLabel = LabelWithInsets()
        countDayLabel.text = countDayString + "1"
        countDayLabel.textColor = CustomColors.textLabel
        countDayLabel.backgroundColor = CustomColors.backgroundLabel
        
        dayStepper = UIStepper()
        dayStepper.minimumValue = 1
        dayStepper.maximumValue = 30
        dayStepper.backgroundColor = CustomColors.backgroundButton
        dayStepper.layer.cornerRadius = 8
        dayStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        
        [tableView,
         emptyLabel,
         totalLabel,
         orderButton,
         changeDateButton,
         dateLabel,
         countDayLabel,
         dayStepper].forEach { view.addSubview($0) }
    }
    
    private func createConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
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
            
            emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constraints.bottom),
            orderButton.widthAnchor.constraint(equalToConstant: 250),
            orderButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
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
    func showNoInternetConnection() {
        let alert = UIAlertController(title: "Ошибка", message: "Нет соединения с Интернетом", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать позже", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateDateLabel(newDate: String) {
        dateLabel.text = "Дата начала аренды: \(newDate)"
    }
    
    func updateTotal(newTotalCost: Int) {
        totalLabel.text = "Итого: " + String(newTotalCost) + " руб."
    }
    
    func updateTable() {
        tableView.reloadData()
    }

    func failure(error: Error) {
        print(error.localizedDescription)
        let showError =  { [weak self] in
            guard let self = self else { return }
            self.showAlert(message: "Нет соединения с интернетом")
        }
        closeAlert(completion: showError)
    }
    
    func showAlert(smallMessage: String) {
        
        
        let alert = UIAlertController(title: nil, message: smallMessage, preferredStyle: .alert)
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
    
    func closeAlert(completion: (() -> ())? ) {
        dismiss(animated: true) {
            if let completion = completion {
                completion()
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func closeAlert(completionMessage: String?) {
        if !(self.presentedViewController?.isBeingDismissed ?? true) {
            dismiss(animated: true) {
                if let competionMessage = completionMessage {
                    self.showAlert(message: competionMessage)
                }
            }
        }
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
        let number = presenter.getNumberOfRow()
        if number == 0 {
            emptyLabel.isHidden = false
        } else {
            emptyLabel.isHidden = true
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}

class LabelWithInsets: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
}

