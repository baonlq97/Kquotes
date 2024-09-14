//
//  SettingViewController+CollectionView.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 13/09/2024.
//

import Foundation
import UIKit

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    var tags: [String] = ["Science", "Technology", "Math", "Literature", "Philosophy", "Engineering"]

    internal func setupCollectionView() {
        // Register your custom cell nib
        let nib = UINib(nibName: TagCollectionViewCell.identifier, bundle: nil)
        tagCollectionView.register(nib, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
    }

    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ["Science", "Technology", "Math", "Literature", "Philosophy", "Engineering"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath
        ) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.tagLabel.text = ["Science", "Technology", "Math", "Literature", "Philosophy", "Engineering"][indexPath.item]
        
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Dequeue the cell
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.identifier,
            for: indexPath
        ) as? TagCollectionViewCell else {
            return .zero
        }

        // Call the method to adjust the cell size dynamically based on the label content
        return cell.adjustCellSize(height: 50, label: ["Science", "Technology", "Math", "Literature", "Philosophy", "Engineering"][indexPath.item])
    }
}
