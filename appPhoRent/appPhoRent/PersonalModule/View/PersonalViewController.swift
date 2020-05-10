//
//  PersonalViewController.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    var presenter: PersonalPresenterProtocol!
    
    var secondView = UIView()
    var avatarImageView: UIImageView!
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    var emailValueLabel: UILabel!
    var phoneLabel: UILabel!
    var phoneValueLabel: UILabel!
    var changePhoneButton: UIButton!
//    var logOutButton: UIButton!
    var aboutUsButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Personal"

        setupUI()
        createConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if presenter.needDownload() {
            showAlert()
        }
    }
    // MARK: - ButtonActions
    
    @objc func aboutUsAction(_ sender: UIButton) {
        presenter.showAboutUs()
    }
    
//    @objc func logOutAction(_ sender: UIButton) {
//        presenter.logOut()
//    }
    
    @objc func changePhoneAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Изменение номера", message: "Введите номер:", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
            textField.delegate = self
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert, weak self] (_) in
            self?.presenter.checkPhone(phone: alert?.textFields![0].text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - PersonalViewProtocol

extension PersonalViewController: PersonalViewProtocol {
    func updateFields(name: String, email: String, phone: String, titleChangePhone: String) {
        phoneValueLabel.text = phone
        changePhoneButton.setTitle(titleChangePhone, for: .normal)
        nameLabel.text = name
        emailValueLabel.text = email
    }
    
    func updatePhoneLabel(phone: String) {
        changePhoneButton.setTitle("изменить номер", for: .normal)
        phoneValueLabel.text = phone
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
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
        secondView.backgroundColor = CustomColors.background
        
        avatarImageView = UIImageView(image: UIImage(named: "photo"))
        
        if let imageUrl = presenter.getImageUrl() {
            if let image = UIImage(contentsOfFile: imageUrl.path) {
                avatarImageView.image = image
            }
        }
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 70
        avatarImageView.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        emailLabel.textAlignment = .right
        
        emailValueLabel = UILabel()
        emailValueLabel.numberOfLines = 0
        emailValueLabel.font = emailValueLabel.font.withSize(20)
        
        phoneLabel = UILabel()
        phoneLabel.text = "Телефон"
        phoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        phoneLabel.textAlignment = .right
        
        phoneValueLabel = UILabel()
        phoneValueLabel.numberOfLines = 0
        phoneValueLabel.font = phoneValueLabel.font.withSize(20)
        
        [nameLabel,
         emailLabel,
         emailValueLabel,
         phoneLabel,
         phoneValueLabel].forEach {
            $0?.textColor = CustomColors.textLabel
        }
        
        changePhoneButton = UIButton(type: .system)
        changePhoneButton.backgroundColor = .white
        changePhoneButton.setTitleColor(.systemBlue, for: .normal)
        changePhoneButton.backgroundColor = CustomColors.background
        
        changePhoneButton.addTarget(self, action: #selector(changePhoneAction), for: .touchUpInside)
        
        
//        logOutButton = UIButton(type: .system)
//        logOutButton.setTitle("Выйти из аккаунта", for: .normal)
//        logOutButton.setTitleColor(.red, for: .normal)
//        logOutButton.layer.borderColor = UIColor.systemGray.cgColor
//        logOutButton.layer.borderWidth = 0.5
//        
//        logOutButton.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
//        
        aboutUsButton = UIButton(type: .system)
        aboutUsButton.setTitle("Настройки", for: .normal)
        aboutUsButton.layer.borderColor = UIColor.systemGray.cgColor
        aboutUsButton.layer.borderWidth = 0.5
        aboutUsButton.setTitleColor(.black, for: .normal)
        aboutUsButton.setTitleColor(CustomColors.textButton, for: .normal)
        aboutUsButton.backgroundColor = CustomColors.backgroundButton
        
        aboutUsButton.addTarget(self, action: #selector(aboutUsAction), for: .touchUpInside)
        
        secondView.isHidden = true
        
        view.addSubview(secondView)
        
        [avatarImageView,
         nameLabel,
         emailLabel,
         emailValueLabel,
         phoneLabel,
         phoneValueLabel,
         aboutUsButton,
//         logOutButton,
         changePhoneButton].forEach {
            secondView.addSubview($0)
        }
    }
    
    private func createConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailValueLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneValueLabel.translatesAutoresizingMaskIntoConstraints = false
        changePhoneButton.translatesAutoresizingMaskIntoConstraints = false
//        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutUsButton.translatesAutoresizingMaskIntoConstraints = false
        secondView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constraints.top),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.leading),
            avatarImageView.widthAnchor.constraint(equalToConstant: 140),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 32),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constraints.trailing),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 100),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.leading),
            emailLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -30),
            emailLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            emailValueLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 100),
            emailValueLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            emailValueLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: Constraints.trailing),
            emailValueLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: emailValueLabel.bottomAnchor, constant: 40),
            phoneLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.leading),
            phoneLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -30),
            phoneLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            phoneValueLabel.topAnchor.constraint(equalTo: emailValueLabel.bottomAnchor, constant: 40),
            phoneValueLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            phoneValueLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: Constraints.trailing),
            phoneValueLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            changePhoneButton.topAnchor.constraint(equalTo: phoneValueLabel.bottomAnchor, constant: 0),
            changePhoneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constraints.trailing),
            changePhoneButton.heightAnchor.constraint(equalToConstant: 24),
            changePhoneButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
//        NSLayoutConstraint.activate([
//            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            logOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            logOutButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
        
        NSLayoutConstraint.activate([
            aboutUsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constraints.bottom),
            aboutUsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            aboutUsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            aboutUsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            secondView.topAnchor.constraint(equalTo: view.topAnchor),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
