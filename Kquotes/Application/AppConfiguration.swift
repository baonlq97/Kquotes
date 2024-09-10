//
//  AppConfiguration.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation
final class AppConfiguration {
    
    private lazy var plist: [String: Any]? = {
        guard let path = Bundle.main.path(forResource: "Key", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            fatalError("Unable to load Key.plist")
        }
        return plist
    }()
    lazy var apiKey: String = {
        guard let apiKey = plist?["QuoteAPIKey"] as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = plist?["QuoteBaseURL"] as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
