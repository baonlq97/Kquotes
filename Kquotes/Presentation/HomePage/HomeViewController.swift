//
//  HomeViewController.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 06/09/2024.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet private weak var menuButton: UIImageView!
    @IBOutlet private weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var loadMoreLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var homeBookmarkToggleImage: UIImageView!
    
    private var isShowHome: Bool = true
    
    internal var homeViewModel: HomeViewModel? {
        return viewModel as? HomeViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
        quoteLabel.text = "..."
        authorLabel.text = "-"
        
        menuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.menuButtonTouched(_:))))
        menuButton.isUserInteractionEnabled = true
        
        loadMoreLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.loadMoreTouched(_:))))
        loadMoreLabel.isUserInteractionEnabled = true
        
        favoriteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favoriteImageTouched(_:))))
        favoriteImage.isUserInteractionEnabled = true
        
        homeBookmarkToggleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.homeBookmarkToggleImageTouched(_:))))
        homeBookmarkToggleImage.isUserInteractionEnabled = true
        
        // Fetch the random quote
        homeViewModel?.fetchRandomQuote()
        homeViewModel?.fetchFavoriteQuotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        homeViewModel?.quoteUpdated = { [weak self] in
            guard let self = self, let quote = homeViewModel?.randomQuote else { return }
            self.quoteLabel.text = quote.quote
            self.authorLabel.text = quote.author
            self.favoriteImage.image = .bookmark
            
            if let quotes = self.homeViewModel?.favoriteQuotes {
                if (quotes.contains(where: {$0.quote == quote.quote})) {
                    DispatchQueue.main.async {
                        self.favoriteImage.image = .bookmarkFilled
                    }
                }
            }
        }
        
        homeViewModel?.favoriteQuotesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.favoriteTableView.reloadData()
            }
        }
    }
}

extension HomeViewController {
    
    @objc
    private func homeBookmarkToggleImageTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        if (self.favoriteTableView.isHidden) {
            self.homeBookmarkToggleImage.image = UIImage(systemName: "house")
            self.favoriteTableView.isHidden = false
        }
        else {
            self.homeBookmarkToggleImage.image = UIImage(systemName: "bookmark.square")
            self.favoriteTableView.isHidden = true
        }
    }
    
    @objc
    private func menuButtonTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        SettingViewCoordinator.shared.start()
        
    }
    
    @objc 
    private func loadMoreTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        homeViewModel?.cancelCurrentTask()
        homeViewModel?.fetchRandomQuote()
    }
    
    @objc
    private func favoriteImageTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let quote = homeViewModel?.randomQuote else { return }
        if (self.favoriteImage.image == .bookmarkFilled) {
            homeViewModel?.deleteFavoriteQuote(quote: quote, completion: {
                DispatchQueue.main.async {
                    self.favoriteImage.image = .bookmark
                }
            })
        }
        else {
            homeViewModel?.saveFavoriteQuote(quote: quote, completion: {
                DispatchQueue.main.async {
                    self.favoriteImage.image = .bookmarkFilled
                }
            })
        }
    }
}
