//
//  FetchRandomQuoteUseCase.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 10/09/2024.
//

import Foundation

protocol FetchRandomQuoteUseCase {
    func execute(
        requestValue: FetchRandomQuoteRequestValue,
        completion: @escaping (Result<[Quote], Error>) -> Void
    ) -> Cancellable?
}

class FetchRandomQuoteUseCaseImpl: FetchRandomQuoteUseCase {
    
    private let quoteRepository: QuoteRepository
    
    init(quoteRepository: QuoteRepository) {
        self.quoteRepository = quoteRepository
    }
    
    func execute(requestValue: FetchRandomQuoteRequestValue,
                 completion: @escaping (Result<[Quote], Error>) -> Void) -> Cancellable? {
        
        return quoteRepository.fetchRandomQuote(
            query: requestValue.query,
            completion: { result in
                completion(result)
            }
        )
    }
}

struct FetchRandomQuoteRequestValue {
    let query: QuoteQuery
}
