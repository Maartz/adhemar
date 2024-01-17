import Foundation

class Lexer {
    private let source: String
    private var tokens: [Token] = []
    var start = 0
    var current = 0
    var line = 1

    private let keywords: [String: TokenType] = [
        "let": .LET,
        "and": .AND,
        "class": .CLASS,
        "else": .ELSE,
        "false": .FALSE,
        "for": .FOR,
        "fn": .FUN,
        "if": .IF,
        "nil": .NIL,
        "or": .OR,
        "print": .PRINT,
        "return": .RETURN,
        "super": .SUPER,
        "this": .THIS,
        "true": .TRUE,
        "var": .VAR,
        "while": .WHILE
    ]

    init(source: String) {
        self.source = source
    }

    func scanTokens() -> [Token] {

        while !isAtEnd() {
            // We are at the beginning of the next lexeme.
            start = current
            scanToken()
        }

        tokens.append(Token(type: .EOF, lexeme: "", literal: nil, line: line))
        return tokens
    }

    func isAtEnd() -> Bool {
        return current >= source.count
    }

    func scanToken() -> Token? {
        let c = advance()
        switch c {
        case "(": addToken(type: .LEFT_PAREN)
        case ")": addToken(type: .RIGHT_PAREN)
        case "{": addToken(type: .LEFT_BRACE)
        case "}": addToken(type: .RIGHT_BRACE)
        case ",": addToken(type: .COMMA)
        case ".": addToken(type: .DOT)
        case "-": addToken(type: .MINUS)
        case "+": addToken(type: .PLUS)
        case ";": addToken(type: .SEMICOLON)
        case "*": addToken(type: .STAR)
        case "!":
            addToken(type: match(expected: "=") ? .BANG_EQUAL : .BANG)
        case "=":
            addToken(type: match(expected: "=") ? .EQUAL_EQUAL : .ASSIGN)
        case "<":
            addToken(type: match(expected: "=") ? .LESS_EQUAL : .LESS)
        case ">":
            addToken(type: match(expected: "=") ? .GREATER_EQUAL : .GREATER)
        case "/":
            if match(expected: "/") {
                // A comment goes until the end of the line.
                if peek() != "\n" && !isAtEnd() {
                    advance()
                } else {
                    addToken(type: .SLASH)
                }
            }
        case " ", "\r", "\t":
            break
        case "\n":
            line += 1
        case "\"":
            string()
        case "o":
            if match(expected: "r") {
                addToken(type: .OR)
            }
        default:
            if isDigit(c: c) {
                number()
            } else if isAlpha(c: c) {
                identifier()
            } else {
                error(line, "Unexpected character.")
            }
            break
        }
    return Token(type: .EOF, lexeme: "", literal: nil, line: line)
    }

        func advance() -> Character {
            current += 1
            return source[source.index(source.startIndex, offsetBy: current - 1)]
        }

        func addToken(type: TokenType) {
            addToken(type: type, nil)
        }

        func addToken(type: TokenType, _ literal: Any?) {
            let text = String(source[source.index(source.startIndex, offsetBy: start)..<source.index(source.startIndex, offsetBy: current)])
            tokens.append(Token(type: type, lexeme: text, literal: literal, line: line))
        }

        func match(expected: Character) -> Bool {
            if isAtEnd() {
                return false
            }
            if source[source.index(source.startIndex, offsetBy: current)] != expected {
                return false
            }

            current += 1
            return true
        }

        func peek() -> Character {
            if isAtEnd() {
                return "\0"
            }

            return source[source.index(source.startIndex, offsetBy: current)]
        }

        func string() {
            while peek() != "\"" && !isAtEnd() {
                if peek() == "\n" {
                    line += 1
                }
                advance()
            }

            // Unterminated string.
            if isAtEnd() {
                error(line, "Unterminated string.")
                return
            }

            // The closing ".
            advance()

            // Trim the surrounding quotes.
            let value = String(source[source.index(source.startIndex, offsetBy: start + 1)..<source.index(source.startIndex, offsetBy: current - 1)])
            addToken(type: .STRING, value)
        }

        func isDigit(c: Character) -> Bool {
            return c >= "0" && c <= "9"
        }

        func peekNext() -> Character {
            if current + 1 >= source.count {
                return "\0"
            }
            return source[source.index(source.startIndex, offsetBy: current + 1)]
        }

        func isAlpha(c: Character) -> Bool {
            return (c >= "a" && c <= "z") ||
            (c >= "A" && c <= "Z") ||
            c == "_"
        }

        func isAlphanumeric(c: Character) -> Bool {
            return isAlpha(c: c) || isDigit(c: c)
        }

        func number() {
            while isDigit(c: peek()) {
                advance()
            }

            // Look for a fractional part.
            if peek() == "." && isDigit(c: peekNext()) {
                // Consume the "."
                advance()

                while isDigit(c: peek()) {
                    advance()
                }
            }

            let value = Double(source[source.index(source.startIndex, offsetBy: start)..<source.index(source.startIndex, offsetBy: current)])!
            addToken(type: .NUMBER, value)
        }

        func identifier() {
            while isAlphanumeric(c: peek()) {
                advance()
            }

            // See if the identifier is a reserved word.
            let text = String(source[source.index(source.startIndex, offsetBy: start)..<source.index(source.startIndex, offsetBy: current)])
            if let type = keywords[text] {
                addToken(type: type)
            } else {
                addToken(type: .IDENTIFIER)
            }
        }

        func error(_ line: Int, _ message: String) {
            report(line, "", message)
        }

        func report(_ line: Int, _ where: String, _ message: String) {
            print("[line \(line)] Error\(`where`): \(message)")
        }
}
