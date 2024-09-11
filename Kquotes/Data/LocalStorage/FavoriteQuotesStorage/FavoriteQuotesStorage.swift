//
//  FavoriteQuotesStorage.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 11/09/2024.
//

import Foundation

protocol FavoriteQuotesStorage {
    func fetchFavorites(completion: @escaping (Result<[Quote]?, Error>) -> Void)
    func save(quote: Quote, completion: @escaping () -> Void)
}
