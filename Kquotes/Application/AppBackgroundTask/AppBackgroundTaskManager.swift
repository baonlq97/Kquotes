//
//  AppBackgroundTaskManager.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 17/09/2024.
//

import Foundation
import BackgroundTasks
import UserNotifications

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    private init() {}
    
    var fetchQuoteUseCase: FetchRandomQuoteUseCase?
    var categoryManager: QuoteCategoryStorageImpl?
    var quoteScheduledManager: QuoteScheduleStorageImpl?
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.brandon.Kquotes.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleBackgroundTask() {
        guard let scheduledTime = QuoteScheduleStorageImpl.shared.scheduleTime else { return }
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.hour, .minute], from: scheduledTime)
        dateComponents.second = 0
        
        let now = Date()
        var scheduledDate = calendar.date(from: dateComponents) ?? Date()
        
        if scheduledDate <= now {
            scheduledDate = calendar.date(byAdding: .day, value: 1, to: scheduledDate) ?? Date()
        }
        
        let request = BGAppRefreshTaskRequest(identifier: "com.brandon.Kquotes.refresh")
        request.earliestBeginDate = scheduledDate
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Daily quote refresh scheduled for \(scheduledDate)")
        } catch {
            print("Could not schedule daily quote refresh: \(error)")
        }
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        guard let fetchQuoteUseCase = fetchQuoteUseCase,
              let categoryManager = categoryManager else {
            task.setTaskCompleted(success: false)
            return
        }
        
        let fetchOperation = BlockOperation {
            _ = fetchQuoteUseCase.execute(requestValue: FetchRandomQuoteRequestValue(query: QuoteQuery(category: categoryManager.selectedCategoryRawValue())), completion: { [weak self] result in
                switch result {
                case .success(let quotes):
                    if let quote = quotes.first {
                        self?.scheduleLocalNotification(with: quote)
                        self?.quoteScheduledManager?.scheduledQuote = quote
                    }
                    task.setTaskCompleted(success: true)
                    self?.scheduleBackgroundTask() // Reschedule for the next day
                case .failure(let error):
                    print("Error fetching quote: \(error)")
                    task.setTaskCompleted(success: false)
                }
            })
        }
        
        task.expirationHandler = {
            fetchOperation.cancel()
            task.setTaskCompleted(success: false)
        }
        
        fetchOperation.start()
    }
    
    private func scheduleLocalNotification(with quote: Quote) {
        let content = UNMutableNotificationContent()
        content.title = "Quote of the Day"
        content.body = quote.quote
        content.sound = .default
        content.userInfo = ["quote": quote.quote, "author": quote.author, "category": quote.category]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
