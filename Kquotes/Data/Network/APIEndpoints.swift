//
//  APIEndpoint.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 10/09/2024.
//

import Foundation

struct APIEndpoints {
    static func getRandomQuote(with quoteRequestDTO: QuoteRequestDTO) -> Endpoint<[QuoteResponseDTO]> {

        return Endpoint(
            path: "v1/quotes",
            method: .get,
            queryParametersEncodable: quoteRequestDTO
        )
    }
}
