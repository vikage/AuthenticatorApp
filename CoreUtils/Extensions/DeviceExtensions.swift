//
//  DeviceExtensions.swift
//  _idx_Core_swift_A742E473_ios_min12.0
//
//  Created by Thanh Vu on 08/07/2021.
//

import Foundation
import UIKit

public extension UIDevice {
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
