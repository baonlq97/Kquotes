//
//  AppDelegate.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 06/09/2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appDIContainer: AppDIContainer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else { return true }
        
        let categoryManager = QuoteCategoryStorageImpl.shared
        if (categoryManager.selectedCategory == nil) {
            categoryManager.selectCategory(Category.all)
        }
        
        HomeViewCoordinator.shared.start(data: window)
        
        return true
    }


}

