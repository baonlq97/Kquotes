//
//  QuoteScheduleStorageImpl.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 17/09/2024.
//

import Foundation

class QuoteScheduleStorageImpl: QuoteScheduleStorage {
    static let shared = QuoteScheduleStorageImpl()
    
    private let scheduledTimeKey = "scheduledTimeKey"
    private let scheduledQuoteKey = "scheduledQuoteKey"
    private init() {}
    
    var scheduleTime: Date? {
        get {
            return UserDefaultsStorage.shared.retrieve(forKey: scheduledTimeKey, as: Date.self)
        }
        set {
            if let time = newValue {
                UserDefaultsStorage.shared.save(time, forKey: scheduledTimeKey)
            } else {
                UserDefaultsStorage.shared.remove(forKey: scheduledTimeKey)
            }
        }
    }
    
    var scheduledQuote: Quote? {
        get {
            return UserDefaultsStorage.shared.retrieve(forKey: scheduledQuoteKey, as: Quote.self)
        }
        set {
            if let quote = newValue {
                UserDefaultsStorage.shared.save(quote, forKey: scheduledQuoteKey)
            } else {
                UserDefaultsStorage.shared.remove(forKey: scheduledQuoteKey)
            }
        }
    }
}
