//
//  QuoteEntity+Mapping.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 11/09/2024.
//

import Foundation
import CoreData

extension QuoteEntity {
    func toQuote() -> Quote {
        return .init(quote: quote ?? "",
                     author: author ?? "",
                     category: category ?? "")
    }
    
    static func toQuotes(_ quoteEntities: [QuoteEntity]) -> [Quote] {
        return quoteEntities.map { $0.toQuote() }
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdAt = Date()
    }
}

extension Quote {
    func toEntity(in context: NSManagedObjectContext) -> QuoteEntity {
        let entity: QuoteEntity = .init(context: context)
        entity.author = author
        entity.quote = quote
        entity.category = category
        return entity
    }
}
