//
//  SettingViewModel.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation

class SettingViewModel: BaseViewModel {
    var categoryManager = QuoteCategoryStorageImpl.shared
    
    func isCategorySelected(_ category: Category) -> Bool{
        return categoryManager.isCategorySelected(category)
    }
    
    func selectCategory(_ category: Category) {
        categoryManager.selectCategory(category)
    }
}
