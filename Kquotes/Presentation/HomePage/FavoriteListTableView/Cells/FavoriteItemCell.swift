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
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var shareButton: UIImageView!
    
}
