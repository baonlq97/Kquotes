//
//  QuoteRepository.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation

protocol QuoteRepository {
    @discardableResult
    func fetchRandomQuote(
        query: QuoteQuery,
//        cached: @escaping ([Quote]) -> Void,
        completion: @escaping (Result<[Quote], Error>) -> Void
    ) -> Cancellable?
    
    func fetchFavoriteQuotes(completion: @escaping (Result<[Quote]?, Error>) -> Void)
    
    func save(quote: Quote, completion: @escaping () -> Void)
    
    func delete(quote: Quote, completion: @escaping () -> Void)
}
