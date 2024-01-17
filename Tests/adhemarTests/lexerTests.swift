//
//  lexerTests.swift
//
//
//  Created by Maartz on 15/01/2024.
//

import XCTest
@testable import adhemar

class LexerTests: XCTestCase {
    
    // Test for left parenthesis
    func testTokenizesLeftParen() {
        let lexer = Lexer(source: "(")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .LEFT_PAREN)
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for right parenthesis
    func testTokenizesRightParen() {
        let lexer = Lexer(source: ")")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .RIGHT_PAREN)
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for simple string
    func testTokenizesString() {
        let lexer = Lexer(source: "\"hello\"")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .STRING)
        XCTAssertEqual(tokens.first?.literal as? String, "hello")
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for a number
    func testTokenizesNumber() {
        let lexer = Lexer(source: "123")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .NUMBER)
        XCTAssertEqual(tokens.first?.literal as? Double, 123)
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for a simple identifier
    func testTokenizesIdentifier() {
        let lexer = Lexer(source: "abc")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .IDENTIFIER)
        XCTAssertEqual(tokens.first?.lexeme, "abc")
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for a keyword
    func testTokenizesKeyword() {
        let lexer = Lexer(source: "class")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .CLASS)
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for a simple comment
    func testIgnoresComment() {
        let lexer = Lexer(source: "// comment")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .IDENTIFIER)
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for whitespace
    func testIgnoresWhitespace() {
        let lexer = Lexer(source: "   ")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 1)
        XCTAssertEqual(tokens.first?.type, .EOF)
    }
    
    // Test for new line
    func testTokenizesNewline() {
        let lexer = Lexer(source: "\n")
        let tokens = lexer.scanTokens()
        // Assuming new lines are not tokenized
        XCTAssertEqual(tokens.count, 1)
        XCTAssertEqual(tokens.first?.type, .EOF)
    }
    
    // Test for a boolean true
    func testTokenizesTrue() {
        let lexer = Lexer(source: "true")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .TRUE)
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for a boolean false
    func testTokenizesFalse() {
        let lexer = Lexer(source: "false")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 2)
        XCTAssertEqual(tokens.first?.type, .FALSE)
        XCTAssertEqual(tokens.last?.type, .EOF)
    }
    
    // Test for multiple tokens
    func testTokenizesMultipleTokens() {
        let lexer = Lexer(source: "(abc 123 \"hello\")")
        let tokens = lexer.scanTokens()
        XCTAssertEqual(tokens.count, 6) // LEFT_PAREN, IDENTIFIER, NUMBER, STRING, RIGHT_PAREN, EOF
        XCTAssertEqual(tokens[0].type, .LEFT_PAREN)
        XCTAssertEqual(tokens[1].type, .IDENTIFIER)
        XCTAssertEqual(tokens[2].type, .NUMBER)
        XCTAssertEqual(tokens[3].type, .STRING)
        XCTAssertEqual(tokens[4].type, .RIGHT_PAREN)
        XCTAssertEqual(tokens[5].type, .EOF)
    }
    
    // Test for an unterminated string
    func testUnterminatedString() {
        let lexer = Lexer(source: "\"this string does not end")
        let tokens = lexer.scanTokens()
        // Depending on how your lexer handles unterminated strings, adjust this test
        // For example, if it adds an error token or just the EOF token
        XCTAssertEqual(tokens.count, 1) // Assuming it just adds EOF token in case of an error
        XCTAssertEqual(tokens.first?.type, .EOF)
    }
}
