//
//  HomeViewDIContainer.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 11/09/2024.
//

import Foundation

final class HomeViewDIContainer {
    func makeHomeViewModel() -> HomeViewModel {
        let appDIContainer = AppDIContainer()
        
        let transferService = appDIContainer.apiDataTransferService
        let favoriteStorage = appDIContainer.favoriteQuotesStorage()
        
        let repository = QuoteRepositoryImpl(dataTransferService: transferService,
                                             localStorage: favoriteStorage)
        let fetchRandomQuoteUseCase = FetchRandomQuoteUseCaseImpl(quoteRepository: repository)
        let fetchFavoriteQuotesUseCase = FetchFavoriteQuotesUseCaseImpl(quoteRepository: repository)
        let saveQuoteUseCase = SaveQuoteUseCaseImpl(quoteRepository: repository)
        
        return HomeViewModel(
            fetchQuoteUseCase: fetchRandomQuoteUseCase,
            fetchFavoriteUseCase: fetchFavoriteQuotesUseCase,
            saveQuoteUseCase: saveQuoteUseCase
        )
    }
}
