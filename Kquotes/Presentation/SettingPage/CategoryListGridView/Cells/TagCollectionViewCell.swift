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
        self.background.layer.cornerRadius = 24
        self.tagLabel.numberOfLines = 0
    }

}
