//
//  BaseViewController.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    var viewModel: BaseViewModel

    init(viewModel: BaseViewModel? = nil) {
        self.viewModel = viewModel ?? BaseViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
//        setupUI()
        bindViewModel()
    }
    
    func bindViewModel() {
//            isLoading
//                .distinctUntilChanged()
//                .throttle(.microseconds(100), scheduler: MainScheduler.instance)
//                .asDriverOnErrorJustComplete()
//                .drive()
//                .disposed(by: rx.disposeBag)
//            
//            viewModel
//                .loading
//                .asDriver()
//                .drive(onNext: { self.handleActivityIndicator(state: $0) })
//                .disposed(by: rx.disposeBag)
//            
//            viewModel.isLoading ~> isLoading ~ rx.disposeBag
        }
}
