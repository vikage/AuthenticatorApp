//
//  CMTimeExtensions.swift
//  CoreUtils
//
//  Created by linzsc on 27/08/2021.
//

import Foundation
import AVFoundation

public extension CMTime {
    func descriptionString() -> String {
        let second = Int(self.seconds.rounded())
        let hh = Int(second / 3600)
        let mm = Int(second % 3600 / 60)
        let ss = second % 60

        if hh == 0 {
            return String(format: "%02d:%02d", mm,ss)
        }

        return String(format: "%02d:%02d:%02d", hh,mm,ss)
    }

    func fullDescriptionString() -> String {
        let second = Int(self.seconds.rounded())
        let hh = Int(second / 3600)
        let mm = Int(second % 3600 / 60)
        let ss = second % 60

        return String(format: "%02d:%02d:%02d", hh,mm,ss)
    }

    func shortDescriptionString() -> String {
        let second = Int(self.seconds.rounded())
        let ss = second % 60
        let mm = second / 60
        return String(format: "%02d:%02d", mm, ss)
    }
}
