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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quoteLabel.text = "..."
        authorLabel.text = "-"
        
        menuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.menuButtonTouched(_:))))
        menuButton.isUserInteractionEnabled = true
        
        loadMoreLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.loadMoreTouched(_:))))
        
        loadMoreLabel.isUserInteractionEnabled = true
        
        // Fetch the random quote
        guard let viewModel = viewModel as? HomeViewModel else { return }
        viewModel.fetchRandomQuote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? HomeViewModel else { return }
        
        viewModel.quoteUpdated = { [weak self] in
            guard let self = self, let quote = viewModel.randomQuote else { return }
            self.quoteLabel.text = quote.quote
            self.authorLabel.text = quote.author
        }
    }
}

extension HomeViewController {
    @objc private func menuButtonTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        SettingViewCoordinator.shared.start()
        
    }
    
    @objc private func loadMoreTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let viewModel = viewModel as? HomeViewModel else { return }
        viewModel.cancelCurrentTask()
        viewModel.fetchRandomQuote()
    }
}
