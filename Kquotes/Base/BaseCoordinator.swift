//
//  ApplicationFlowCordinator.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation

protocol BaseCoordinator: AnyObject {
    func start(data: Any?)
}

extension BaseCoordinator {
    func start(data: Any? = nil) {
        self.start(data: nil)
    }
}
