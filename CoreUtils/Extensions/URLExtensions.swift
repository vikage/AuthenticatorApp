//
//  URLExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation

public extension URL {
    var params: [String:Any] {
        guard let query = self.query else { return [:] }
        let paramsComponent = query.components(separatedBy: "&")

        var paramsResult = [String:Any]()
        paramsComponent.forEach { (item) in
            let components = item.components(separatedBy: "=")
            let key = components[0]
            let value = components[1]

            paramsResult[key] = value
        }

        return paramsResult
    }
}
