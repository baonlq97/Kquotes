//
//  FetchFavoriteQuoteUseCase.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 11/09/2024.
//

import Foundation

protocol FetchFavoriteQuotesUseCase {
    func execute(
        completion: @escaping (Result<[Quote]?, Error>) -> Void
    )
}

class FetchFavoriteQuotesUseCaseImpl: FetchFavoriteQuotesUseCase {
    private let quoteRepository: QuoteRepository
    
    init(quoteRepository: QuoteRepository) {
        self.quoteRepository = quoteRepository
    }
    
    
    func execute(completion: @escaping (Result<[Quote]?, Error>) -> Void) {
        quoteRepository.fetchFavoriteQuotes(completion: completion)
    }
}
