//
//  SaveQuoteUseCase.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 11/09/2024.
//

import Foundation

protocol SaveQuoteUseCase {
    func execute(
        quote: Quote,
        completion: @escaping () -> Void
    )
}

class SaveQuoteUseCaseImpl: SaveQuoteUseCase {
    private let quoteRepository: QuoteRepository
    
    init(quoteRepository: QuoteRepository) {
        self.quoteRepository = quoteRepository
    }
    
    
    func execute(quote: Quote, completion: @escaping () -> Void) {
        quoteRepository.save(quote: quote, completion: completion)
    }
}
