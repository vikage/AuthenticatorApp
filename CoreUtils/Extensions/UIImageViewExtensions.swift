//
//  UIImageViewExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import UIKit

private struct Keys {
    static var gifFrames: UInt8 = 0
    static var gifDuration: UInt8 = 0
}

public extension UIImageView {
    var gifFrames: [UIImage]? {
        set {
            objc_setAssociatedObject(self, &Keys.gifFrames, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            return objc_getAssociatedObject(self, &Keys.gifFrames) as? [UIImage]
        }
    }

    var gifDuration: TimeInterval {
        set {
            objc_setAssociatedObject(self, &Keys.gifDuration, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            return objc_getAssociatedObject(self, &Keys.gifDuration) as? TimeInterval ?? 0
        }
    }

    func animateGif(data: Data, duration: CGFloat) {
        let images = UIImage.getImagesFromGifData(data)
        self.animationImages = images
        self.animationDuration = TimeInterval(duration)
        self.animationRepeatCount = 0
        self.startAnimating()
    }

    func displayFirstFrameOfGif(data: Data) {
        let firstFrame = UIImage.getFirstFrameOfGifData(data)
        self.image = firstFrame
    }
}
