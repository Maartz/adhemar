//
//  ast.swift
//  
//
//  Created by Maartz on 14/01/2024.
//

protocol Node {
   func tokenLiteral() -> String 
}

protocol Statement: Node {
}

protocol Expression: Node {
    func expressionNode()
}

struct Program {
    var statements: [Statement] = []

    func tokenLiteral() -> String {
        if statements.count > 0 {
            return statements[0].tokenLiteral()
        } else {
            return ""
        }
    }
}

struct LetStatement: Statement {
    let token: Token // the token.LET token
    var name: Identifier?
    var value: Expression?

    func tokenLiteral() -> String {
        return token.literal as! String
    }

    func statementNode() {}
}

struct Identifier: Expression {
    let token: Token // the token.IDENT token
    let value: String?

    func tokenLiteral() -> String {
        return token.literal as! String
    }

    func expressionNode() {}
}
