//
//  PersonalPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation

protocol PersonalViewProtocol: class {
    func updateFields(name: String, email: String, phone: String, titleChangePhone: String)
    func updatePhoneLabel(phone: String)
    func showAlert()
    func closeAlert()
    func showErrorAlert()
}

protocol PersonalPresenterProtocol: class {
    init(view: PersonalViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    
    func setPhone(phone: String)
    func needDownload() -> Bool
    func checkPhone(phone: String?)
    func showAboutUs()
    func logOut()
}

class PersonalPresenter: PersonalPresenterProtocol {
    weak var view: PersonalViewProtocol?
    var router: RouterProtocol?
    let networkService: NetWorkServiceProtocol!
    var userID: String?
    
    required init(view: PersonalViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        setInfo()
//        ref = Database.database().reference()
//        userID = Auth.auth().currentUser?.uid
//        
//        ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let value = snapshot.value as? NSDictionary
//            let name = value?["name"] as? String ?? ""
//            let email = value?["email"] as? String ?? ""
//            let phone = value?["phone"] as? String
//            
//            UserManager.shared.currentUser = PersonalData(name: name, email: email, phone: phone)
//            
//            DispatchQueue.main.async {
//                if let data = UserManager.shared.currentUser  {
//                    var titleChangePhone = "добавить номер"
//                    var phone = ""
//                    if let _ = data.phone {
//                        titleChangePhone = "изменить номер"
//                        phone = data.phone!
//                    }
//                    view.updateFields(name: data.name, email: data.email, phone: phone, titleChangePhone: titleChangePhone)
//                    view.closeAlert()
//                }
//            }
//            
//        }) { (error) in
//            print("Error: ")
//            print(error.localizedDescription)
//        }
    }
    
    func setInfo() {
        networkService.getPersonalInfo { [weak self] result in
        guard let self = self else { return }
            DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                print("Error: ")
                print(error.localizedDescription)
            case .success(let personData):
                UserManager.shared.currentUser = personData
                if let data = UserManager.shared.currentUser  {
                   var titleChangePhone = "добавить номер"
                   var phone = ""
                   if let _ = data.phone {
                       titleChangePhone = "изменить номер"
                       phone = data.phone!
                   }
                    print(personData)
                    self.view?.updateFields(name: data.name, email: data.email, phone: phone, titleChangePhone: titleChangePhone)
                    self.view?.closeAlert()
                }
                }
            }
        }
    }
    
    //MARK: - PersonalViewPresenterProtocol
    
    func setPhone(phone: String) {
        networkService.setPhone(phone: phone) { [weak self] result in
        guard let self = self else { return }
            DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                print("Error: ")
                print(error.localizedDescription)
            case .success(let message):
                print(message)
                UserManager.shared.currentUser?.phone = phone
                self.view?.updatePhoneLabel(phone: phone)
                }
            }
        }
    }
    
    func needDownload() -> Bool {
        return UserManager.shared.currentUser == nil
    }
    
    func checkPhone(phone: String?){
        if let phone = phone {
            if phone.count == 11 {
                setPhone(phone: phone)
            } else {
                view?.showErrorAlert()
            }
        }
    }
    
    func showAboutUs() {
        router?.showAboutUs()
    }
    
    func logOut() {
        networkService.signOut { [weak self] result in
        guard let self = self else { return }
            DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                print("Error: ")
                print(error.localizedDescription)
            case .success(let message):
                print(message)
                self.router?.logOut()
                }
            }
        }
    }
}
