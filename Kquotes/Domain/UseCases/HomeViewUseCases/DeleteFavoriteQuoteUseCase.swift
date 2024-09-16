//
//  DeleteFavoriteQuoteUseCase.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 12/09/2024.
//

import Foundation

protocol DeleteFavoriteQuoteUseCase {
    func execute(
        quote: Quote,
        completion: @escaping () -> Void
    )
}

class DeleteFavoriteQuoteUseCaseImpl: DeleteFavoriteQuoteUseCase {
    private let quoteRepository: QuoteRepository
    
    init(quoteRepository: QuoteRepository) {
        self.quoteRepository = quoteRepository
    }
    
    
    func execute(quote: Quote, completion: @escaping () -> Void) {
        quoteRepository.delete(quote: quote, completion: completion)
    }
}
