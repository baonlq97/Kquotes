//
//  QuoteRepositoryImpl.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 10/09/2024.
//

import Foundation

final class QuoteRepositoryImpl {

    private let dataTransferService: DataTransferService
//    private let cache: MoviesResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue

    init(
        dataTransferService: DataTransferService,
//        cache: MoviesResponseStorage,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
//        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

extension QuoteRepositoryImpl: QuoteRepository {
    func fetchRandomQuote(query: QuoteQuery,
//                          cached: @escaping ([Quote]) -> Void,
                          completion: @escaping (Result<[Quote], Error>) -> Void) -> Cancellable? {
        
        let requestDTO = QuoteRequestDTO(category: query.category)
        let task = RepositoryTask()

//        cache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
//
//            if case let .success(responseDTO?) = result {
//                cached(responseDTO.toDomain())
//            }
//            guard !task.isCancelled else { return }
//
//            let endpoint = APIEndpoints.getMovies(with: requestDTO)
//            task.networkTask = self?.dataTransferService.request(
//                with: endpoint,
//                on: backgroundQueue
//            ) { result in
//                switch result {
//                case .success(let responseDTO):
//                    self?.cache.save(response: responseDTO, for: requestDTO)
//                    completion(.success(responseDTO.toDomain()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
        
        guard !task.isCancelled else { return nil }
        
        let endpoint = APIEndpoints.getRandomQuote(with: requestDTO)
        task.networkTask = self.dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { result in
            switch result {
            case .success(let responseDTOs):
//                self?.cache.save(response: responseDTO, for: requestDTO)
                completion(.success(QuoteResponseDTO.toDomains(responseDTOs)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
