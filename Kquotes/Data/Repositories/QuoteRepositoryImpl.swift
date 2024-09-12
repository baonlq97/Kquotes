//
//  QuoteRepositoryImpl.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 10/09/2024.
//

import Foundation

final class QuoteRepositoryImpl {

    private let dataTransferService: DataTransferService
    private let localStorage: FavoriteQuotesStorage
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        dataTransferService: DataTransferService,
        localStorage: FavoriteQuotesStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.localStorage = localStorage
        self.backgroundQueue = backgroundQueue
    }
}

extension QuoteRepositoryImpl: QuoteRepository {
    
    func fetchFavoriteQuotes(completion: @escaping (Result<[Quote]?, Error>) -> Void) {
        return localStorage.fetchFavorites(completion: completion)
    }
    
    func save(quote: Quote, completion: @escaping () -> Void) {
        localStorage.save(quote: quote,
                          completion: completion)
    }
    
    func delete(quote: Quote, completion: @escaping () -> Void) {
        localStorage.delete(quote: quote, 
                            completion: completion)
    }
    
    func fetchRandomQuote(query: QuoteQuery,
                          completion: @escaping (Result<[Quote], Error>) -> Void) -> Cancellable? {
        
        let requestDTO = QuoteRequestDTO(category: query.category)
        let task = RepositoryTask()
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoints.getRandomQuote(with: requestDTO)
        task.networkTask = self.dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTOs):
                completion(.success(QuoteResponseDTO.toDomains(responseDTOs)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
