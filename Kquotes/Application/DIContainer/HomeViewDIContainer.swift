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
        let saveFavoriteQuoteUseCase = SaveFavoriteQuoteUseCaseImpl(quoteRepository: repository)
        let deleteFavoriteQuoteUseCase = DeleteFavoriteQuoteUseCaseImpl(quoteRepository: repository)
        
        return HomeViewModel(
            fetchQuoteUseCase: fetchRandomQuoteUseCase,
            fetchFavoriteQuotesUseCase: fetchFavoriteQuotesUseCase,
            saveFavoriteQuoteUseCase: saveFavoriteQuoteUseCase,
            deleteFavoriteQuoteUseCase: deleteFavoriteQuoteUseCase
        )
    }
}
