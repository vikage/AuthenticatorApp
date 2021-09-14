//
//  UIViewControllerExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import ObjectiveC

private struct Keys {
    static var disposeBagKey = ""
}

public extension UIViewController {
    func topVC() -> UIViewController {
        if let navigation = self as? UINavigationController, !navigation.viewControllers.isEmpty {
            return navigation.topViewController!.topVC()
        }
        
        if let presentedVC = self.presentedViewController {
            return presentedVC.topVC()
        }
        
        return self
    }

    var disposeBag: DisposeBag {
        if let bag = objc_getAssociatedObject(self, &Keys.disposeBagKey) as? DisposeBag {
            return bag
        }

        let bag = DisposeBag()
        objc_setAssociatedObject(self, &Keys.disposeBagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bag
    }
}
