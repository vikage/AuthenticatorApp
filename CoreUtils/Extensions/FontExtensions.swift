//
//  FontExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    class func fontWithSize(_ size: CGFloat, fontWeight: UIFont.Weight = UIFont.Weight.regular) -> UIFont {
        switch fontWeight {
        case .regular:
            return self.regularFont(withSize: size)
        case .medium:
            return self.mediumFont(withSize: size)
        case .bold:
            return self.boldFont(withSize: size)
        case .semibold:
            return self.semiboldFont(withSize: size)
        default:
            return self.regularFont(withSize: size)
        }
    }

    private static func regularFont(withSize size: CGFloat) -> UIFont {
        return UIFont.init(name: "TitilliumWeb-Regular", size: size)!
    }

    private static func mediumFont(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }

    private static func boldFont(withSize size: CGFloat) -> UIFont {
        return UIFont.init(name: "TitilliumWeb-Bold", size: size)!
    }

    private static func semiboldFont(withSize size: CGFloat) -> UIFont {
        return UIFont.init(name: "TitilliumWeb-SemiBold", size: size)!
    }
}
