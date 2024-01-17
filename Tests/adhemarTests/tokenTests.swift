//
//  tokenTests.swift
//
//
//  Created by Maartz on 15/01/2024.
//

import XCTest
@testable import adhemar

class TokenTests: XCTestCase {

    func testTokenInitialization() {
        let type: TokenType = .IDENTIFIER // Replace with an actual enum value of TokenType
        let lexeme = "testLexeme"
        let literal: Any? = "testLiteral"
        let line = 1

        let token = Token(type: type, lexeme: lexeme, literal: literal, line: line)

        XCTAssertEqual(token.type, type, "Incorrect token type.")
        XCTAssertEqual(token.lexeme, lexeme, "Incorrect lexeme.")
        XCTAssertEqual(token.literal as? String, literal as? String, "Incorrect literal.")
        XCTAssertEqual(token.line, line, "Incorrect line number.")
    }

    func testDescription() {
        let type: TokenType = .STRING // Replace with an actual enum value of TokenType
        let lexeme = "example"
        let literal: Any? = "exampleLiteral"
        let line = 2

        let token = Token(type: type, lexeme: lexeme, literal: literal, line: line)
        let description = token.description()

        let expectedDescription = "\(type) \(lexeme) \(String(describing: literal))"
        XCTAssertEqual(description, expectedDescription, "Description method did not return expected string.")
    }

    // Additional test for a different type of token, if needed
    func testDifferentTokenTypeDescription() {
        let type: TokenType = .NUMBER // Replace with a different enum value of TokenType
        let lexeme = "123"
        let literal: Any? = 123
        let line = 3

        let token = Token(type: type, lexeme: lexeme, literal: literal, line: line)
        let description = token.description()

        let expectedDescription = "\(type) \(lexeme) \(String(describing: literal))"
        XCTAssertEqual(description, expectedDescription, "Description method did not return expected string for a number token.")
    }
}

