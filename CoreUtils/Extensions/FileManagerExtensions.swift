//
//  FileManagerExtensions.swift
//  Core
//
//  Created by Thanh Vu on 10/06/2021.
//  Copyright © 2021 Solar. All rights reserved.
//

import Foundation

public extension FileManager {
    static func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }

    static func documentURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    static func cacheURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
    }
    
    static func musicPath() -> String {
        return self.documentPath().appending("/music")
    }
    
    static func filePath() -> String {
        return self.documentPath().appending("/file")
    }
    
    static func importedSoundEffectPath() -> String {
        return self.documentPath().appending("/imported_sound_effect")
    }
    
    static func importedMusicPath() -> String {
        return self.documentPath().appending("/imported_music")
    }
    
    static func musicURL() -> URL {
        return URL(fileURLWithPath: self.musicPath())
    }
    
    static func createRequireDirs() {
        createDirIfNeeded(path: self.filePath())
        createDirIfNeeded(path: self.musicPath())
        createDirIfNeeded(path: self.importedMusicPath())
        createDirIfNeeded(path: self.importedSoundEffectPath())
    }
    
    private static func createDirIfNeeded(path: String) {
        var isDirectoryOutput: ObjCBool = false
        let pointer = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        pointer.initialize(from: &isDirectoryOutput, count: 1)
        
        if FileManager.default.fileExists(atPath: path, isDirectory: pointer) == false || isDirectoryOutput.boolValue == false {
            try? FileManager.default.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
        }
    }
}
