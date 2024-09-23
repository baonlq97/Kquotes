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
        
        if (count == 0) {
            let label = UILabel()
            label.text = "No favorite item added"
            label.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        }
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
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
            cell.favoriteButtonTouched = { [weak self] quote in
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
            
            cell.shareButtonTouched = { [weak self] quote in
                guard let self = self else { return }
                let textToShare = "\(quote.quote)" + "\n\n" + "- \(quote.author) -"
                let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = tableView
                    popoverController.sourceRect = tableView.rectForRow(at: indexPath)
                }
                
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
        return cell
    }
}
