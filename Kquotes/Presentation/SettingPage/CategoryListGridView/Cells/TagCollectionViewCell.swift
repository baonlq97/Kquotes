//
//  TagCollectionViewCell.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 13/09/2024.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TagCollectionViewCell"
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round corners for the cell's content view
        self.background.layer.cornerRadius = 20
//        self.contentView.layer.masksToBounds = true
        
        // Set border or shadow (optional)
        self.background.layer.borderWidth = 1
        self.background.layer.borderColor = self.contentView.backgroundColor?.cgColor
        self.tagLabel.numberOfLines = 0
    }
    
    func adjustCellSize(height: CGFloat, label: String) -> CGSize {
        self.tagLabel.text = label
        
        // Target size - width is compressed, height is a given constant
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: height)
        
        // Returns the optimal size for the contentView using Auto Layout
        return self.contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel, // Let the width be flexible
            verticalFittingPriority: .required // Height should remain fixed
        )
    }

}
