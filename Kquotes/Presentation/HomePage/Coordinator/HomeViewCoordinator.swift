//
//  HomeViewCoordinator.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import UIKit

class HomeViewCoordinator : BaseCoordinator {
    
    static let shared = HomeViewCoordinator()
    
    func start(data: Any?) {
        guard let window = data as? UIWindow else { return }
        
        let vc = HomeViewController()
        vc.viewModel = HomeViewDIContainer().makeHomeViewModel()
        
        let nav = UINavigationController(rootViewController: vc)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
