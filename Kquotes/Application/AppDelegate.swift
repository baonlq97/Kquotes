//
//  AppDelegate.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 06/09/2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appDIContainer: AppDIContainer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.appDIContainer = AppDIContainer()
        
        guard let window = window else { return true }
        guard let transferService = appDIContainer?.apiDataTransferService else { return true }
        
        let repository = QuoteRepositoryImpl(dataTransferService: transferService)
        let useCase = FetchRandomQuoteUseCaseImpl(quoteRepository: repository)
        HomeViewCoordinator.shared.start(data: window, quoteUseCase: useCase)
        
        return true
    }


}

