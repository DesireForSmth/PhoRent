//
//  PersonalPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Foundation
//import FirebaseStorage
//
//
//////
//import FirebaseAuth
//import FirebaseFirestore

protocol PersonalViewProtocol: class {
    func updateFields(name: String, email: String, phone: String, imageURL: URL?)
    func updatePhoneLabel(phone: String)
    func showAlert()
    func closeAlert()
    func showErrorAlert()
}

protocol PersonalPresenterProtocol: class {
    init(view: PersonalViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol)
    
    static var imageFileName: String { get }
    func setInfo()
    func setPhone(phone: String)
    func needDownload() -> Bool
    func checkPhone(phone: String?)
    func showAboutUs()
    func saveImage(dataImage: Data)
    func getImageUrl() -> URL?
}

class PersonalPresenter: PersonalPresenterProtocol {
    weak var view: PersonalViewProtocol?
    var router: RouterProtocol!
    let networkService: NetWorkServiceProtocol!
    var userID: String?
    
    static var imageFileName = "avatarPhoto"
    private let fileManager = FileManager.default
    
    required init(view: PersonalViewProtocol, router: RouterProtocol, networkService: NetWorkServiceProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        //        setInfo()
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
                    if let data = UserManager.shared.currentUser {
                        let phone = data.phone ?? ""
                        self.view?.updateFields(name: data.name, email: data.email, phone: phone, imageURL: self.getImageUrl())
                        //                        self.view?.closeAlert()
                    }
                }
            }
        }
    }
    
    //MARK: - PersonalPresenterProtocol
    
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
        guard let _ = UserManager.shared.currentUser else { return true}
//        let phone = data.phone ?? ""
        //        view?.updateFields(name: data.name, email: data.email, phone: phone, imageURL: getImageUrl())
        return false
    }
    
    func checkPhone(phone: String?){
        if let phone = phone {
            if phone.count == 17 {
                setPhone(phone: phone)
            } else {
                view?.showErrorAlert()
            }
        }
    }
    
    func showAboutUs() {
        router?.showAboutUs()
    }
    
    // MARK: - For FileManager
    //
    //    private func filePath(for key: String) -> URL? {
    //        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    //
    //        return url?.appendingPathComponent(key + ".jpeg")
    //    }
    
    //    func saveImage(dataImage: Data) {
    //
    //        guard let url = filePath(for: PersonalPresenter.imageFileName) else { return }
    //        do {
    //            try dataImage.write(to: url)
    //        } catch {
    //            print(error)
    //        }
    //    }
    
    func saveImage(dataImage: Data) {
        networkService.saveImage(dataImage: dataImage)
    }
    
    func getImageUrl() -> URL? {
        return URL(string: UserManager.shared.currentUser?.imageURLString ?? "")
        
        //        guard let url = filePath(for: PersonalPresenter.imageFileName) else {
        //            return nil
        //        }
        //        return url
    }
}
