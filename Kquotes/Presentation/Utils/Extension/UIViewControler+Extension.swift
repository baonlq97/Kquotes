//
//  UIViewControler+Extension.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 09/09/2024.
//

import UIKit

extension UIViewController {
    func isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func getRootViewController() -> UIViewController {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return BaseViewController()
        }

        if  let rootVC = appDelegate.window?.rootViewController as? BaseViewController {
            return rootVC
        }
        if let rootNav = appDelegate.window?.rootViewController as? UINavigationController, let firstVC = rootNav.viewControllers.first as? BaseViewController {
            return firstVC
        }
        return BaseViewController()
    }
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            let xibName = String(describing: T.self)
            return T.init(nibName: xibName, bundle: nil)
        }
        
        return instantiateFromNib()
    }
        
    static func getNavigationViewController() -> UINavigationController {
        let viewController = self.loadFromNib()
        return UINavigationController.init(rootViewController: viewController)
    }
}
