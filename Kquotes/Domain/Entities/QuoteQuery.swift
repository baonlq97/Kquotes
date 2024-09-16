//
//  QuoteQuery.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 10/09/2024.
//

import Foundation

enum Category: String {
    case all = ""
    case happiness = "happiness"
    case art = "art"
    case courage = "courage"
    case family = "family"
    case health = "health"
    case success = "success"
    
    static var allCategories: [Category] = [.all, .happiness, .art, .courage, .family, .health, .success]
}

struct QuoteQuery {
    let category: String
}
