//
//  TableViewExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    func registerCell<T>(type: T.Type, bundle: Bundle? = nil) {
        let name = String(describing: type)
        let targetBundle = bundle != nil ? bundle : Bundle(for: type.self as! AnyClass)
        self.register(UINib(nibName: name, bundle: targetBundle), forCellReuseIdentifier: name)
    }

    func dequeueCell<T>(type: T.Type) -> T? {
        let name = String(describing: type)
        return self.dequeueReusableCell(withIdentifier: name) as? T
    }

    func dequeueCell<T>(type: T.Type, indexPath: IndexPath) -> T? {
        let name = String(describing: type)
        return self.dequeueReusableCell(withIdentifier: name, for: indexPath) as? T
    }
}
