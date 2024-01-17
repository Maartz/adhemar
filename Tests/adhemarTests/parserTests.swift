//
//  File.swift
//  
//
//  Created by Maartz on 15/01/2024.
//

import XCTest
@testable import adhemar

class ParserTests: XCTestCase {
    func testLetStatements() {
        let input = """
        let x = 5;
        let y = 10;
        let foobar = 838383;
        """
        let lexer = Lexer(source: input)
        let parser = Parser(lexer: lexer)
        
        let program = parser.parseProgram()
        if program == nil {
            XCTFail("ParseProgram() returned nil")
            return
        }
        
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 3)
        
        let tests = [
            "x",
            "y",
            "foobar"
        ]
        
        for (index, test) in tests.enumerated() {
            let stmt = (program.statements[index])!
            testLetStatement(stmt, test)
        }
    }

    func testLetStatement(_ s: Statement, _ name: String) {
        XCTAssertEqual(s.tokenLiteral(), "let")
        
        guard let letStmt = s as? LetStatement else {
            XCTFail("s not LetStatement. got=\(s)")
            return
        }
        
        XCTAssertEqual(letStmt.name?.value, name)
        XCTAssertEqual(letStmt.name?.tokenLiteral(), name)
    }
}
