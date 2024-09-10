//
//  SettingViewCoordinator.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import UIKit

class SettingViewCoordinator : BaseCoordinator {
    
    static let shared = SettingViewCoordinator()
    
    func start(data: Any?) {
//        guard let data = data as? SettingViewModel else { return }
        let vc = SettingViewController()
        vc.viewModel = SettingViewModel()
        vc.getRootViewController().navigationController?.pushViewController(vc, animated: true)
    }
}
