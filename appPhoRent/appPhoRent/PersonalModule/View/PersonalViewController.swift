//
//  PersonalViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalViewController: UIViewController {
    var presenter: PersonalPresenterProtocol!
    
    var secondView = UIView()
    var avatarImageView: UIImageView!
    var nameLabel: UILabel!
    var emailImageView: UIImageView!
    var emailValueLabel: UILabel!
    var phoneImageView: UIImageView!
    var phoneValueLabel: UILabel!
    var changePhoneButton: UIButton!
    var aboutUsButton: UIButton!
    
    var outerView: UIView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Профиль"
        
        setupUI()
        createConstraints()
        presenter.setInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if presenter.needDownload() {
            showAlert()
        } else {
            secondView.isHidden = false
        }
    }
    // MARK: - ButtonActions
    
    @objc func aboutUsAction(_ sender: UIButton) {
        presenter.showAboutUs()
    }
    
    @objc func changePhoneAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Изменение номера", message: "Введите номер:", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
            textField.delegate = self
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert, weak self] (_) in
            self?.presenter.checkPhone(phone: alert?.textFields![0].text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - PersonalViewProtocol

extension PersonalViewController: PersonalViewProtocol {
    func updateFields(name: String, email: String, phone: String, imageURL: URL?) {
        phoneValueLabel.text = phone
        nameLabel.text = name
        emailValueLabel.text = email
        
        if let imageURL = imageURL {
            avatarImageView.kf.setImage(with: imageURL)
        }
        closeAlert()
    }
    
    func updatePhoneLabel(phone: String) {
        phoneValueLabel.text = phone
    }
    
    func showAlert() {
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
        secondView.isHidden = false
    }
    
    func showErrorAlert() {
        let errorAlert = UIAlertController(title: "Неверный формат номера", message: "", preferredStyle: .alert)
        
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension PersonalViewController: UITextFieldDelegate {
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "X (XXX) XXX-XX-XX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PersonalViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func didSelectImage(image: UIImage?) {
        avatarImageView.image = image
        guard let data = image?.jpegData(compressionQuality: 1) else { return }
        presenter.saveImage(dataImage: data)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[.editedImage] as? UIImage
        didSelectImage(image: image)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Create UI

extension PersonalViewController {
    
    private func setupUI() {
        view.backgroundColor = CustomColors.background
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.addTarget(self, action: #selector(aboutUsAction), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItem = barButton
        
        avatarImageView = UIImageView(image: UIImage(named: "photo"))
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 70
        avatarImageView.layer.masksToBounds = true
        
        outerView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        outerView.layer.shadowRadius = 3
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 70).cgPath
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        outerView.addSubview(avatarImageView)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        emailImageView = UIImageView(image: UIImage(systemName: "envelope"))
        emailImageView.contentMode = .scaleAspectFit
        emailImageView.tintColor = CustomColors.textLabel
        
        emailValueLabel = UILabel()
        emailValueLabel.numberOfLines = 0
        emailValueLabel.font = emailValueLabel.font.withSize(20)
        
        phoneImageView = UIImageView(image: UIImage(systemName: "phone"))
        phoneImageView.contentMode = .scaleAspectFit
        phoneImageView.tintColor = CustomColors.textLabel
        
        phoneValueLabel = UILabel()
        phoneValueLabel.numberOfLines = 0
        phoneValueLabel.font = phoneValueLabel.font.withSize(20)
        
        [nameLabel,
         emailValueLabel,
         phoneValueLabel].forEach {
            $0?.textColor = CustomColors.textLabel
        }
        
        changePhoneButton = UIButton(type: .system)
        changePhoneButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        changePhoneButton.tintColor = CustomColors.backgroundButton
        changePhoneButton.backgroundColor = .clear
        changePhoneButton.isOpaque = false
        changePhoneButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        changePhoneButton.addTarget(self, action: #selector(changePhoneAction), for: .touchUpInside)
        
        secondView.isHidden = true
        
        view.addSubview(secondView)
        
        [outerView,
         nameLabel,
         emailImageView,
         emailValueLabel,
         phoneImageView,
         phoneValueLabel,
         changePhoneButton].forEach {
            secondView.addSubview($0)
        }
    }
    
    private func createConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        outerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailImageView.translatesAutoresizingMaskIntoConstraints = false
        emailValueLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false
        phoneValueLabel.translatesAutoresizingMaskIntoConstraints = false
        changePhoneButton.translatesAutoresizingMaskIntoConstraints = false
        secondView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constraints.top),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.leading),
            avatarImageView.widthAnchor.constraint(equalToConstant: 140),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            outerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constraints.top),
            outerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.leading),
            outerView.widthAnchor.constraint(equalToConstant: 140),
            outerView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constraints.trailing),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            emailImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 100),
            emailImageView.widthAnchor.constraint(equalToConstant: 30),
            emailImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
            emailImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            emailValueLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 100),
            emailValueLabel.leadingAnchor.constraint(equalTo: emailImageView.trailingAnchor, constant: 32),
            emailValueLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: Constraints.trailing),
            emailValueLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            phoneImageView.topAnchor.constraint(equalTo: emailValueLabel.bottomAnchor, constant: 40),
            phoneImageView.widthAnchor.constraint(equalToConstant: 30),
            phoneImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
            phoneImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            phoneValueLabel.topAnchor.constraint(equalTo: emailValueLabel.bottomAnchor, constant: 40),
            phoneValueLabel.leadingAnchor.constraint(equalTo: phoneImageView.trailingAnchor, constant: 32),
            phoneValueLabel.widthAnchor.constraint(equalToConstant: 180),
            phoneValueLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            changePhoneButton.centerYAnchor.constraint(equalTo: phoneValueLabel.centerYAnchor),
            changePhoneButton.leadingAnchor.constraint(equalTo: phoneValueLabel.trailingAnchor, constant: Constraints.leading),
            changePhoneButton.heightAnchor.constraint(equalToConstant: 62),
            changePhoneButton.widthAnchor.constraint(equalToConstant: 62)
        ])
        
        NSLayoutConstraint.activate([
            secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            secondView.topAnchor.constraint(equalTo: view.topAnchor),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
