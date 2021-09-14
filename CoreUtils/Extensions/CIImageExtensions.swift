//
//  CIImageExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import UIKit

public extension CIImage {
    func toUIImage() -> UIImage {
           let context: CIContext = CIContext.init(options: nil)
           let cgImage: CGImage = context.createCGImage(self, from: self.extent)!
           let image: UIImage = UIImage.init(cgImage: cgImage)
           return image
    }
}
