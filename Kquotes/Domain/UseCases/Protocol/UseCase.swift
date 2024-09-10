//
//  UseCases.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
