//
//  PersonalPresenter.swift
//  appPhoRent
//
//  Created by Elena Kacharmina on 09.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import Firebase

protocol PersonalViewProtocol: class {
    func updateFields(name: String, email: String, phone: String, titleChangePhone: String)
    func updatePhoneLabel(phone: String)
    func showAlert()
    func closeAlert()
    func showErrorAlert()
}

protocol PersonalViewPresenterProtocol: class {
    init(view: PersonalViewProtocol, router: RouterProtocol)
    
    var data: PersonalData? {get set}
    
    func setPhone(phone: String)
    func needDownload() -> Bool
    func checkPhone(phone: String?)
    func showAboutUs()
    func logOut()
}

class PersonalPresenter: PersonalViewPresenterProtocol {
    weak var view: PersonalViewProtocol?
    var router: RouterProtocol?
    var data: PersonalData?
    var ref: DatabaseReference?
    var userID: String?
    
    required init(view: PersonalViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
        ref = Database.database().reference()
        userID = Auth.auth().currentUser?.uid
        
        ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let phone = value?["phone"] as? String
            self.data = PersonalData(name: name, email: email, phone: phone)
            
            DispatchQueue.main.async {
                if let data = self.data {
                    var titleChangePhone = "добавить номер"
                    var phone = ""
                    if let _ = data.phone {
                        titleChangePhone = "изменить номер"
                        phone = data.phone!
                    }
                    view.updateFields(name: data.name, email: data.email, phone: phone, titleChangePhone: titleChangePhone)
                    view.closeAlert()
                }
            }
            
        }) { (error) in
            print("Error: ")
            print(error.localizedDescription)
        }
    }
    
    //MARK: - PersonalViewPresenterProtocol
    
    func setPhone(phone: String) {
        ref?.child("users/\(userID!)/phone").setValue(phone)
        view?.updatePhoneLabel(phone: phone)
    }
    
    func needDownload() -> Bool {
        return data == nil
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
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        router?.popToRoot()
    }
}
