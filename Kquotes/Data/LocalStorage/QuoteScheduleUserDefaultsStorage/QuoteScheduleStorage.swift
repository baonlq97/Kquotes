//
//  QuoteScheduleStorage.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 17/09/2024.
//

import Foundation

protocol QuoteScheduleStorage {
    var scheduleTime: Date? { get set }
    var scheduledQuote: Quote? {get set}
}
