//
//  SettingViewController+CollectionView.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 13/09/2024.
//

import Foundation
import UIKit

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    internal func setupCollectionView() {
        // Register your custom cell nib
        let nib = UINib(nibName: TagCollectionViewCell.identifier, bundle: nil)
        tagCollectionView.register(nib, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath
        ) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        
        let category = Category.allCategories[indexPath.item]
        if (category == Category.all) {
            cell.tagLabel.text = "all categories"
        }
        else {
            cell.tagLabel.text = category.rawValue
        }
        
        if let isSelected = settingViewModel?.isCategorySelected(category) {
            cell.background.backgroundColor = isSelected ? .systemGray : .tertiarySystemGroupedBackground
        } else {
            cell.background.backgroundColor = .tertiarySystemGroupedBackground
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var label = ""
        
        if (Category.allCategories[indexPath.item] == Category.all) {
            label = "all categories"
        }
        else {
            label = Category.allCategories[indexPath.item].rawValue
        }
        
        let labelWidth = (label as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).width
        
        let padding: CGFloat = 24
        let cellWidth = labelWidth + padding
        
        return CGSize(width: cellWidth, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = Category.allCategories[indexPath.item]
        settingViewModel?.selectCategory(selectedCategory)
        collectionView.reloadData()
    }
}
