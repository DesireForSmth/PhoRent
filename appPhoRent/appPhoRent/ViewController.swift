//
//  ViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 25.03.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    var window: UIWindow?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       
           print("hello from ViewController")
           Auth.auth().addStateDidChangeListener { (auth, user) in
               if user == nil{
                   self.showModalAuth()
               }else{
                self.showModalApp()
            }
           }
       }
    
    func showModalApp(){
        print("hello from showModalApp")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "AppTabController") as! AppTabController
        print(newvc)
        //show(newvc, sender: self)
        
        newvc.modalPresentationStyle = .fullScreen
        newvc.modalTransitionStyle = .crossDissolve
        
        present(newvc, animated: true, completion: nil)
    }
    
    func showModalAuth(){
        print("hello from showModalAuth")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        print(newvc)
        //show(newvc, sender: self)
        
        newvc.modalPresentationStyle = .fullScreen
        newvc.modalTransitionStyle = .crossDissolve
        
        present(newvc, animated: true, completion: nil)
        //newvc.dismiss(animated: true, completion: nil)
        //self.present(newvc, animated: true, completion: nil)
    }

}

