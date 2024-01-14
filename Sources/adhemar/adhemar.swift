import Foundation

import Foundation

@main
public class Adhemar {
    var hadError: Bool = false

    static func main() throws {
        let adhemar = Adhemar()
        try adhemar.runMain()
    }

    private func runMain() throws {
        let args = CommandLine.arguments
        if args.count > 1 {
            print("Usage: adhemar <script>")
            exit(1)
//        } else if args.count == 1 {
//            Self.runFile(args[0])
        } else {
            print("Adhemar v0.0.1")
            runPrompt()
        }
    }

    static func runFile(_ path: String) {
        let file = URL(fileURLWithPath: path)
        let source = try! String(contentsOf: file)
        run(source)
    }

    func runPrompt() {
        while true {
            print("> ", terminator: "")
            let line = readLine()
            if line == nil {
                break
            }
            Self.run(line!)
            self.hadError = false
        }
    }

    static func run(_ source: String) {
        let lexer = Lexer(source: source)
        let tokens = lexer.scanTokens()
    
        // For now, we just print the tokens.
        for token in tokens {
            print("\(token.type): \(token.lexeme)")
        }
    }

    func error(_ line: Int, _ message: String) {
        report(line, "", message)
    }

    func report(_ line: Int, _ where: String, _ message: String) {
        print("[line \(line)] Error\(`where`): \(message)")
        hadError = true
    }
}
