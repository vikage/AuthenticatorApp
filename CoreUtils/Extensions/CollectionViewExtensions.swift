//
//  CollectionViewExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    func registerCell<T>(type: T.Type, bundle: Bundle? = nil) {
        let name = String(describing: type)
        let targetBundle = bundle != nil ? bundle : Bundle(for: type.self as! AnyClass)
        self.register(UINib(nibName: name, bundle: targetBundle), forCellWithReuseIdentifier: name)
    }

    func registerHeader<T>(type: T.Type, bundle: Bundle? = nil) {
        let name = String(describing: type)
        let targetBundle = bundle != nil ? bundle : Bundle(for: type.self as! AnyClass)
        self.register(UINib(nibName: name, bundle: targetBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
    }

    func dequeueCell<T>(type: T.Type, indexPath: IndexPath) -> T? {
        let name = String(describing: type)
        return self.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T
    }

    func dequeueHeader<T>(type: T.Type, indexPath: IndexPath) -> T? {
        let name = String(describing: type)
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name, for: indexPath) as? T
    }
}
