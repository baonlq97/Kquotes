//
//  UserDefaultsStorage.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 16/09/2024.
//

import Foundation

class UserDefaultsStorage {
    static let shared = UserDefaultsStorage()

    private let userDefaults = UserDefaults.standard

    private init() {}

    func save<T: Codable>(_ value: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            userDefaults.set(encoded, forKey: key)
        }
    }

    func retrieve<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        if let data = userDefaults.data(forKey: key) {
            let decoder = JSONDecoder()
            return try? decoder.decode(T.self, from: data)
        }
        return nil
    }

    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
