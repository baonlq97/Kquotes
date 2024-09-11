//
//  AppDIContainer.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 10/09/2024.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "X-Api-Key": appConfiguration.apiKey
            ]
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
   func favoriteQuotesStorage() -> FavoriteQuotesStorage {
        return FavoriteQuotesStorageImpl()
    }
}
