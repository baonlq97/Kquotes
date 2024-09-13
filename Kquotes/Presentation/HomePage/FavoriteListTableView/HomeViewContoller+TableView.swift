//
//  FavoriteListTableViewController.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 12/09/2024.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func setupTableView() {
        favoriteTableView.register(UINib(nibName: "FavoriteItemCell", bundle: nil), forCellReuseIdentifier: FavoriteItemCell.reuseIdentifier)
        favoriteTableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let quotes = self.homeViewModel?.favoriteQuotes {
            count = quotes.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteItemCell.reuseIdentifier,
            for: indexPath) as? FavoriteItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(FavoriteItemCell.self) with reuseIdentifier: \(FavoriteItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if let quotes = self.homeViewModel?.favoriteQuotes {
            cell.bind(quote: quotes[indexPath.row])
            cell.privateButtonTouched = { [weak self] quote in
                self?.homeViewModel?.deleteFavoriteQuote(quote: quote, completion: {
                    DispatchQueue.main.async {
                        // Check if current quote is the same as deleted quote
                        if (self?.homeViewModel?.randomQuote?.quote == quote.quote) {
                            // Reset the bookmart image to unsave
                            self?.favoriteImage.image = .bookmark
                        }
                        tableView.reloadData()
                    }
                })
            }
        }
        
        return cell
    }
}
