//
//  TimeIntervalExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation
import AVFoundation

public extension TimeInterval {
    func toDurationString() -> String {
        let seconds: Int = Int(self) % 60
        let minutes = Int(self / 60)
        return String.init(format: "%02d:%02d", minutes, seconds)
    }
    
    func toDurationStringWithHour() -> String {
        let hours: Int = Int(self) / 3600
        let minutes = Int((Int(self) - hours*3600) / 60)
        let seconds: Int = Int(self) % 60
        
        return String.init(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func cgFloat() -> CGFloat {
        return CGFloat(self)
    }
}

public extension CMTime {
    func toDouble() -> Float64 {
        return CMTimeGetSeconds(self)
    }
}
