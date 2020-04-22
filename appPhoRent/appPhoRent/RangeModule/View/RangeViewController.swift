//
//  RangeViewController.swift
//  appPhoRent
//
//  Created by Ilya Buzyrev on 19.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class RangeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }

    
   

}


//extension RangeViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        
//    }
//    
//    
//}
