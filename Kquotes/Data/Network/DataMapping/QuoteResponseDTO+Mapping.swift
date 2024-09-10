//
//  QuoteResponseDTO+Mapping.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 10/09/2024.
//

import Foundation

struct QuoteResponseDTO: Decodable {
    let quote: String
    let author: String
    let category: String
}

extension QuoteResponseDTO {
    func toDomain() -> Quote {
        return .init(quote: quote,
                     author: author,
                     category: category)
    }
    
    static func toDomains(_ responseDTOs: [QuoteResponseDTO]) -> [Quote] {
        return responseDTOs.map { $0.toDomain() }
    }
}
