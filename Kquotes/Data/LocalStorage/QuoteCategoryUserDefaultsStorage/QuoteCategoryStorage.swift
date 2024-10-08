//
//  QuoteCategoryStorage.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 16/09/2024.
//

import Foundation

protocol QuoteCategoryStorage {
    var selectedCategory: Category? {get set}
    func isCategorySelected(_ category: Category) -> Bool
    func selectCategory(_ category: Category)
    func selectedCategoryRawValue() -> String
}
