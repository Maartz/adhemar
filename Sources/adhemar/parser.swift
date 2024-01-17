class Parser {
    var lexer: Lexer
    var curToken: Token?
    var peekToken: Token?

    init(lexer: Lexer) {
        self.lexer = lexer

        self.nextToken()
        self.nextToken()
    }

    func nextToken() {
        curToken = peekToken
        peekToken = self.lexer.scanToken()
    }

    func parseProgram() -> Program? {
       var program = Program()

         while curToken?.type != .EOF {
              if let stmt = self.parseStatement() {
                program.statements.append(stmt)
              }
              self.nextToken()
         }
        
        return program
    }

    func parseStatement() -> Statement? {
        switch curToken?.type {
        case .LET:
            return self.parseLetStatement()
        default:
            return nil
        }
    }

    func parseLetStatement() -> LetStatement? {
        var stmt: LetStatement = LetStatement(token: curToken!)

        guard self.expectPeek(.IDENTIFIER) else {
            return nil
        }

        stmt.name = Identifier(token: curToken!, value: curToken!.literal as? String)

        guard self.expectPeek(.ASSIGN) else {
            return nil
        }

        while !(self.curTokenIs(.SEMICOLON)) {
            self.nextToken()
        }

        return stmt
    }

    func curTokenIs(_ t: TokenType) -> Bool {
        return self.curToken?.type == t
    }

    func peekTokenIs(_ t: TokenType) -> Bool {
        return self.peekToken?.type == t
    }

    func expectPeek(_ t: TokenType) -> Bool {
        if self.peekTokenIs(t) {
            self.nextToken()
            return true
        } else {
            return false
        }
    }
}
