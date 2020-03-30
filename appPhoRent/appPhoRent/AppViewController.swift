//
//  AppViewController.swift
//  appPhoRent
//
//  Created by Александр Сетров on 30.03.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit
import Firebase

class AppViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
        print("hello from showModalView")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        print(newvc)
        //show(newvc, sender: self)
        
        newvc.modalPresentationStyle = .fullScreen
        newvc.modalTransitionStyle = .crossDissolve
        
        present(newvc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
