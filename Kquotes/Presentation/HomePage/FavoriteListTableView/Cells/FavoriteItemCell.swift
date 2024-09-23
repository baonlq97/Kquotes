//
//  FavoriteItemCell.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 12/09/2024.
//

import Foundation
import UIKit

final class FavoriteItemCell: UITableViewCell {
    static let reuseIdentifier = String(describing: FavoriteItemCell.self)
    
    @IBOutlet private weak var quoteLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIImageView!
    @IBOutlet private weak var shareButton: UIImageView!
    
    var favoriteButtonTouched: ((Quote) -> Void)?
    var shareButtonTouched: ((Quote) -> Void)?
    
    private var quote: Quote?
    
    func bind(quote: Quote) {
        self.quote = quote
        quoteLabel.text = self.quote?.quote
        authorLabel.text = self.quote?.author
        
        favoriteButton.isUserInteractionEnabled = true
        favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favoriteButtonTouched(_:))))
        
        shareButton.isUserInteractionEnabled = true
        shareButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shareButtonTouched(_:))))
    }
    
    @objc
    private func favoriteButtonTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let quote = self.quote else { return }
        favoriteButtonTouched?(quote)
    }
    
    @objc
    private func shareButtonTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let quote = self.quote else { return }
        shareButtonTouched?(quote)
    }
}
