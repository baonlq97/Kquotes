//
//  HomeViewViewModel.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation

class HomeViewModel: BaseViewModel {
    
    let fetchQuoteUseCase: FetchRandomQuoteUseCase
    
    // A property to store the fetched quote
    var randomQuote: Quote? {
        didSet {
            // Notify when the quote is set
            self.quoteUpdated?()
        }
    }
    
    // A closure that will be used to notify the view when the quote is updated
    var quoteUpdated: (() -> Void)?
    
    private let mainQueue: DispatchQueueType
    private var quoteLoadTask: Cancellable? { willSet { quoteLoadTask?.cancel() } }
    
    init(fetchQuoteUseCase: FetchRandomQuoteUseCase,
         mainQueue: DispatchQueueType = DispatchQueue.main) {
        self.fetchQuoteUseCase = fetchQuoteUseCase
        self.mainQueue = mainQueue
    }
    
    func fetchRandomQuote() {
        quoteLoadTask = fetchQuoteUseCase.execute(requestValue: FetchRandomQuoteRequestValue(query: QuoteQuery(category: "happiness")),
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
}
