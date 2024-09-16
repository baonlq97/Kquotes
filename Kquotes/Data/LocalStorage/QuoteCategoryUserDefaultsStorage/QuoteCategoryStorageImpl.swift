//
//  QuoteCategoryStorageImpl.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 16/09/2024.
//

import Foundation

class QuoteCategoryStorageImpl: QuoteCategoryStorage {
    
    static let shared = QuoteCategoryStorageImpl()

    private let selectedCategoryKey = "selectedCategoryKey"

    private init() {}
    
    var selectedCategory: Category? {
        get {
            // Retrieve the raw value from UserDefaults and initialize the enum
            guard let rawValue = UserDefaultsStorage.shared.retrieve(forKey: selectedCategoryKey, as: String.self) else {
                return nil
            }
            return Category(rawValue: rawValue)
        }
        set {
            if let category = newValue {
                // Save the raw value of the enum to UserDefaults
                UserDefaultsStorage.shared.save(category.rawValue, forKey: selectedCategoryKey)
            } else {
                // Remove the category from UserDefaults
                UserDefaultsStorage.shared.remove(forKey: selectedCategoryKey)
            }
        }
    }
    
    func isCategorySelected(_ category: Category) -> Bool {
        return selectedCategory == category
    }
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func selectedCategoryRawValue() -> String {
        return selectedCategory?.rawValue ?? ""
    }
}
