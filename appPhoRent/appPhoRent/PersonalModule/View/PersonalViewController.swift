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
    var aboutUsButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Профиль"

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
    func updateFields(name: String, email: String, phone: String) {
        phoneValueLabel.text = phone
        nameLabel.text = name
        emailValueLabel.text = email
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
        secondView.backgroundColor = CustomColors.background
        
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.addTarget(self, action: #selector(aboutUsAction), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)

        navigationItem.rightBarButtonItem = barButton

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
        changePhoneButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        
        changePhoneButton.backgroundColor = CustomColors.background
        
        changePhoneButton.addTarget(self, action: #selector(changePhoneAction), for: .touchUpInside)
        
        secondView.isHidden = true
        
        view.addSubview(secondView)
        
        [avatarImageView,
         nameLabel,
         emailLabel,
         emailValueLabel,
         phoneLabel,
         phoneValueLabel,
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
            phoneValueLabel.widthAnchor.constraint(equalToConstant: 180),
            phoneValueLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            changePhoneButton.centerYAnchor.constraint(equalTo: phoneValueLabel.centerYAnchor, constant: 0),
            changePhoneButton.leadingAnchor.constraint(equalTo: phoneValueLabel.trailingAnchor, constant: Constraints.leading),
            changePhoneButton.heightAnchor.constraint(equalToConstant: 30),
            changePhoneButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            secondView.topAnchor.constraint(equalTo: view.topAnchor),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
