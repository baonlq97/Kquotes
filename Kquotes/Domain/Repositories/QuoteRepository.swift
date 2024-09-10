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
}
