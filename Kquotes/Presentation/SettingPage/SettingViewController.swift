//
//  SettingViewController.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 06/09/2024.
//

import UIKit

class SettingViewController: BaseViewController {
    @IBOutlet internal weak var tagCollectionView: UICollectionView!
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupCollectionView()
        
        let leftAlignedLayout = LeftAlignedCollectionViewFlowLayout()
        leftAlignedLayout.minimumInteritemSpacing = 8 // Adjust as needed
        leftAlignedLayout.minimumLineSpacing = 8 // Adjust as needed
        leftAlignedLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) // Adjust as needed

        tagCollectionView.collectionViewLayout = leftAlignedLayout
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
}
