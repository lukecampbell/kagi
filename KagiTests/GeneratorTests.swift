//
//  KagiTests.swift
//  KagiTests
//
//  Created by Lucas Campbell on 10/18/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import XCTest
import Kagi

class KagiTests: XCTestCase {
    var generator: Generator?

    override func setUp() {
        generator = Generator()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidCharacters() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let generator = self.generator!
        let validCharacters = generator.getCharacterSets(for: [.Alpha, .Numeric])
        XCTAssertEqual(validCharacters, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    }
    
    func testReadIndexes() {
        let generator = self.generator!
        let values = generator.readIndexes(fromOffset: 0, count: 4)
        let expected: [UInt32] = [1, 3, 6, 10]
        for (i, value) in values.enumerated() {
            XCTAssertEqual(value, expected[i])
        }
    }
    
    func testGetFileSize() {
        let generator = self.generator!
        let value = generator.getIndexFileSize()
        XCTAssertEqual(943544, value)
    }
    
    func testSelectWords() throws {
        let generator = self.generator!
        
        XCTAssertEqual("a", try generator.lookupWord(wordNumber: 0))
        XCTAssertEqual("otorrhea", try generator.lookupWord(wordNumber: 133221))
        XCTAssertEqual("Zyzzogeton", try generator.lookupWord(wordNumber: 235884))
        XCTAssertThrowsError(try generator.lookupWord(wordNumber: 235885))
    }
    
    func testGeneratePassphrase() {
        let generator = self.generator!
        
        let passphrase = generator.generatePassphrase()
        XCTAssertEqual(32, passphrase.count)
    }

}
