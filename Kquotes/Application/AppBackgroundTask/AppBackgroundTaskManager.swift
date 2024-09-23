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
        // Log pending tasks before cancellation
        BGTaskScheduler.shared.getPendingTaskRequests { tasks in
            print("Number of pending tasks before cancellation: \(tasks.count)")
        }

        // Cancel any existing scheduled tasks
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.brandon.Kquotes.refresh")

        guard let scheduledTime = QuoteScheduleStorageImpl.shared.scheduleTime else {
            print("No scheduled time set. Exiting scheduleBackgroundTask().")
            return
        }
        
        print("Scheduled time from storage: \(scheduledTime)")
        
        let calendar = Calendar.current
        print("Current timezone: \(calendar.timeZone)")
        
        // Calculate the background task time (5 minutes before the scheduled time)
        let backgroundTaskTime = calendar.date(byAdding: .minute, value: -5, to: scheduledTime) ?? scheduledTime
        
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let backgroundTaskComponents = calendar.dateComponents([.hour, .minute], from: backgroundTaskTime)
        
        dateComponents.hour = backgroundTaskComponents.hour
        dateComponents.minute = backgroundTaskComponents.minute
        dateComponents.second = 0
        
        print("Date components for scheduling: \(dateComponents)")
        
        guard let scheduledDate = calendar.date(from: dateComponents) else {
            print("Failed to create scheduled date")
            return
        }
        
        print("Initial scheduled date: \(scheduledDate)")
        
        let now = Date()
        print("Current date: \(now)")
        
        var finalScheduledDate = scheduledDate
        
        if finalScheduledDate <= now {
            finalScheduledDate = calendar.date(byAdding: .day, value: 1, to: finalScheduledDate) ?? Date()
            print("Scheduled date was in the past. Adjusted to: \(finalScheduledDate)")
        }
        
        let request = BGAppRefreshTaskRequest(identifier: "com.brandon.Kquotes.refresh")
        request.earliestBeginDate = finalScheduledDate
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Daily quote refresh scheduled for \(finalScheduledDate)")
            
            // Log pending tasks after scheduling
            BGTaskScheduler.shared.getPendingTaskRequests { tasks in
                print("Number of pending tasks after scheduling: \(tasks.count)")
            }
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

        guard let scheduledTime = QuoteScheduleStorageImpl.shared.scheduleTime else { return }
        
        let calendar = Calendar.current
        
        var dateComponents = calendar.dateComponents([.hour, .minute], from: scheduledTime)
        dateComponents.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "com.brandon.Kquotes.dailyQuote", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily quote notification scheduled for \(dateComponents) in user's local time")
            }
        }
    }
}
