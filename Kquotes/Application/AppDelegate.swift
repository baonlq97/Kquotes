//
//  AppDelegate.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 06/09/2024.
//

import UIKit
import BackgroundTasks
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appDIContainer: AppDIContainer?
    var fetchQuoteUseCase: FetchRandomQuoteUseCase!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let appDIContainer = AppDIContainer()
        
        let transferService = appDIContainer.apiDataTransferService
        let favoriteStorage = appDIContainer.favoriteQuotesStorage()
        
        let repository = QuoteRepositoryImpl(dataTransferService: transferService,
                                             localStorage: favoriteStorage)
        
        requestNotificationPermission()
        
        let backgroundTaskManager = BackgroundTaskManager.shared
        backgroundTaskManager.fetchQuoteUseCase = FetchRandomQuoteUseCaseImpl(quoteRepository: repository)
        backgroundTaskManager.categoryManager = QuoteCategoryStorageImpl.shared
        backgroundTaskManager.quoteScheduledManager = QuoteScheduleStorageImpl.shared
        backgroundTaskManager.registerBackgroundTasks()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else { return true }
        
        let categoryManager = QuoteCategoryStorageImpl.shared
        if (categoryManager.selectedCategory == nil) {
            categoryManager.selectCategory(Category.all)
        }
        
        HomeViewCoordinator.shared.start(data: window)
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NotificationCenter.default.post(name: Notification.Name("backgroundFetchedQuote"), object: nil)
    }
}
