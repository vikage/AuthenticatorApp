//
//  BundleExtensions.swift
//  Core
//
//  Created by Thanh Vu on 25/06/2021.
//

import Foundation

public extension Bundle {
    static func resourceBundle(name: String) -> Bundle {
        for bundle in Bundle.allBundles {
            if let path = bundle.path(forResource: name, ofType: "bundle") {
                return Bundle(path: path)!
            }
        }

        fatalError()
    }
}
