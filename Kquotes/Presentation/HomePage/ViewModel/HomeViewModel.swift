//
//  HomeViewViewModel.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation

class HomeViewModel: BaseViewModel {
    
    private let fetchQuoteUseCase: FetchRandomQuoteUseCase
    private let fetchFavoriteQuotesUseCase: FetchFavoriteQuotesUseCase
    private let saveFavoriteQuoteUseCase: SaveFavoriteQuoteUseCase
    private let deleteFavoriteQuoteUseCase: DeleteFavoriteQuoteUseCase
    
    private let categoryManager = QuoteCategoryStorageImpl.shared
    
    var randomQuote: Quote? {
        didSet {
            self.quoteUpdated?()
        }
    }
    var quoteUpdated: (() -> Void)?
    
    var favoriteQuotes: [Quote]? {
        didSet {
            self.favoriteQuotesUpdated?()
        }
    }
    var favoriteQuotesUpdated: (() -> Void)?
    
    
    private let mainQueue: DispatchQueueType
    private var quoteLoadTask: Cancellable? { willSet { quoteLoadTask?.cancel() } }
    
    init(fetchQuoteUseCase: FetchRandomQuoteUseCase,
         fetchFavoriteQuotesUseCase: FetchFavoriteQuotesUseCase,
         saveFavoriteQuoteUseCase: SaveFavoriteQuoteUseCase,
         deleteFavoriteQuoteUseCase: DeleteFavoriteQuoteUseCase,
         mainQueue: DispatchQueueType = DispatchQueue.main) {
        self.fetchQuoteUseCase = fetchQuoteUseCase
        self.fetchFavoriteQuotesUseCase = fetchFavoriteQuotesUseCase
        self.saveFavoriteQuoteUseCase = saveFavoriteQuoteUseCase
        self.deleteFavoriteQuoteUseCase = deleteFavoriteQuoteUseCase
        self.mainQueue = mainQueue
    }
    
    func fetchRandomQuote() {
        quoteLoadTask = fetchQuoteUseCase.execute(requestValue: FetchRandomQuoteRequestValue(query: QuoteQuery(category: categoryManager.selectedCategoryRawValue())),
                                  completion: { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let quotes):
                    self?.randomQuote = quotes.first // Assuming it's an array and you take the first one
                case .failure(let error):
                    print("Error fetching quote: \(error)")
                }
            }
        })
    }
    
    func cancelCurrentTask() {
        quoteLoadTask?.cancel()
    }
    
    func saveFavoriteQuote(quote: Quote, completion: @escaping () -> Void) {
        saveFavoriteQuoteUseCase.execute(quote: quote, completion: {
            self.favoriteQuotes?.append(quote)
            completion()
        })
    }
    
    func fetchFavoriteQuotes() {
        fetchFavoriteQuotesUseCase.execute(completion: { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let quotes):
                    self?.favoriteQuotes = quotes
                case .failure(let error):
                    print("Error fetching quote: \(error)")
                }
            }
        })
    }
    
    func deleteFavoriteQuote(quote: Quote, completion: @escaping () -> Void) {
        deleteFavoriteQuoteUseCase.execute(quote: quote, completion: {
            self.favoriteQuotes?.removeAll(where: {$0 == quote})
            completion()
        })
    }
}
