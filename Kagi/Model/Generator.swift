//
//  Generator.swift
//  Kagi
//
//  Created by Lucas Campbell on 10/18/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import Foundation

public enum GeneratorCharacterSet {
    case Alpha
    case Numeric
    case CommonSpecials
    case FullSpecials
}

public class Generator {
    let LOWERCASE = "abcdefghijklmnopqrstuvwxyz"
    let UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let NUMBERS = "0123456789"
    let SMALLSPECIALS = "!@#$%_-"
    let FULLSPECIALS = "~^&*()_+`-=[]\\{}|;':\",./<>?"
    private var _passphraseLength: Int8 = 32
    private let _wordsPath: URL
    private let _indexFilePath: URL
    private var _indexFileSize: UInt64?
    var memorable: Bool = false
    var passphraseLength: Int8 {
        get { return _passphraseLength }
        set {
            if newValue >= 32 {
                _passphraseLength = 32
            } else if newValue <= 0 {
                _passphraseLength = 1
            } else {
                _passphraseLength = newValue
            }
        }
    }
    
    public init() {
        _wordsPath = Bundle.main.url(forResource: "words", withExtension: nil)!
        _indexFilePath = Bundle.main.url(forResource: "indexes", withExtension: "dat")!
    }
    
    public func getIndexFileSize() -> UInt64 {
        if _indexFileSize != nil {
            return _indexFileSize!
        }
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: Bundle.main.path(forResource: "indexes", ofType: "dat")!)
            _indexFileSize = attr[FileAttributeKey.size] as? UInt64
            return _indexFileSize!
        } catch {
            fatalError("Failed to calculate size of index file \(error)")
        }
    }
    
    public func readIndexes(fromOffset: UInt64, count: UInt8) -> [UInt32] {
        do {
            let fileHandle = try FileHandle(forReadingFrom: _indexFilePath)
            fileHandle.seek(toFileOffset: fromOffset)
            var values = [UInt32]()
            for _ in 0..<count {
                let dataString = fileHandle.readData(ofLength: 4)
                dataString.withUnsafeBytes { (ptr: UnsafePointer<UInt32>) in
                    values.append(UInt32(littleEndian: ptr.pointee))
                }
            }
            return values
        } catch {
            fatalError("Failed to read indexes from file \(error)")
        }
    }
    
    private func readWord(fromOffset: UInt64) -> String {
        do {
            let fileHandle = try FileHandle(forReadingFrom: _wordsPath)
            fileHandle.seek(toFileOffset: fromOffset+1)
            let buffer = fileHandle.readData(ofLength: 64)
            for (i, c) in buffer.enumerated() {
                if c == 0x0A {
                    return String(bytes: buffer.subdata(in: 0..<i), encoding: .utf8)!
                }
            }
            return String(bytes: buffer, encoding: .utf8)!
        } catch {
            fatalError("Failed to read from dictionary \(error)")
        }
    }
    
    public func lookupWord(wordNumber: UInt32) throws -> String {
        let indexFileSize = getIndexFileSize()
        let entryCount = indexFileSize / 4 - 2
        if wordNumber > entryCount {
            throw GeneratorError.indexError("Word number \(wordNumber) exceeds max word count \(entryCount)")
        }
        let indexes = readIndexes(fromOffset: UInt64(wordNumber*4), count: 1)
        return readWord(fromOffset: UInt64(indexes[0]))
    }
    
    public func selectWords(number count: Int8) -> [String] {
        var words = [String]()
        let indexFileSize = getIndexFileSize()
        let entryCount = indexFileSize / 4 - 2
        for _ in 0..<count {
            let selection = UInt64.random(in: 0..<entryCount)
            let indexes = readIndexes(fromOffset: selection*4, count: 1)
            let wordOffset = indexes[0]
            words.append(readWord(fromOffset: UInt64(wordOffset)))
        }
        return words
    }
    
    public func getCharacterSets(for charset: [GeneratorCharacterSet]) -> String {
        var sets = [String]()
        for set in charset {
            if set == .Alpha {
                sets.append(LOWERCASE + UPPERCASE)
            } else if set == .Numeric {
                sets.append(NUMBERS)
            } else if set == .CommonSpecials {
                sets.append(SMALLSPECIALS)
            } else if set == .FullSpecials {
                sets.append(FULLSPECIALS)
            }
        }
        return sets.joined()
    }
}
