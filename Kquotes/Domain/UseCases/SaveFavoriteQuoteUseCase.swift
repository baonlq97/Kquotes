//
//  SaveQuoteUseCase.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 11/09/2024.
//

import Foundation

protocol SaveFavoriteQuoteUseCase {
    func execute(
        quote: Quote,
        completion: @escaping () -> Void
    )
}

class SaveFavoriteQuoteUseCaseImpl: SaveFavoriteQuoteUseCase {
    private let quoteRepository: QuoteRepository
    
    init(quoteRepository: QuoteRepository) {
        self.quoteRepository = quoteRepository
    }
    
    
    func execute(quote: Quote, completion: @escaping () -> Void) {
        quoteRepository.save(quote: quote, completion: completion)
    }
}
