//
//  Tokenizer.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class Tokenizer {
    class TokenInfo {
        var regex: NSRegularExpression
        var token: Int
        init(regex: NSRegularExpression, token: Int){
            self.regex = regex
            self.token = token
        }
    }
    
    private struct ExpressionTokenizer {
        static var expressionTokenizer:Tokenizer? = nil
    }
    
    private var tokenInfos: Array<TokenInfo>
    private var tokens: Array<Token>
    
    init(){
        tokenInfos = Array<TokenInfo>()
        tokens = Array<Token>()
    }
    
    class func getExpressionTokenizer() -> Tokenizer{
        if (ExpressionTokenizer.expressionTokenizer == nil) {
            ExpressionTokenizer.expressionTokenizer = createExpressionTokenizer()
        }
        return ExpressionTokenizer.expressionTokenizer!
    }
    
    private class func createExpressionTokenizer() -> Tokenizer {
        var tokenizer:Tokenizer = Tokenizer()

        tokenizer.add("[+-]", token: Token.plusminus)
        tokenizer.add("[*/]", token: Token.multdiv)
        tokenizer.add("\\^", token: Token.raised)
        
        var funcs:String = FunctionExpressionNode.getAllFunctions()
        tokenizer.add("(" + funcs + ")(?!\\w)", token: Token.function)
        
        tokenizer.add("\\(", token: Token.openBracket)
        tokenizer.add("\\)", token: Token.clouseBracket)
        tokenizer.add("(?:\\d+\\.?|\\.\\d)\\d*(?:[Ee][-+]?\\d+)?", token: Token.number)
        tokenizer.add("[a-zA-Z]\\w*", token: Token.variable)
        
        return tokenizer
    }
    
    private func add(regex: String, token: Int) {
        let options = NSRegularExpressionOptions.CaseInsensitive |
            NSRegularExpressionOptions.DotMatchesLineSeparators
        tokenInfos.append(TokenInfo(
            regex: NSRegularExpression(pattern: "^(\(regex))", options: options, error: nil)!,
            token: token
            )
        )
    }
    
    
    func tokenize(str: String){
        var s = String(str)
        s.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        tokens.removeAll(keepCapacity: false)
        let totalLength: Int = s.utf16Count
        while !s.isEmpty {
            var match: Bool = false
            var remaining:Int = s.utf16Count
            for info in tokenInfos {
                let reg = info.regex
                let m = reg.matchesInString(s, options: nil, range: NSRange(location: 0, length:s.utf16Count)) as Array<NSTextCheckingResult>
                if !m.isEmpty {
                    match = true
                    let  tok = (s as NSString).substringWithRange(m.first!.rangeAtIndex(1))
                    tokens.append(Token(token: info.token, sequence: tok, pos: totalLength - remaining))
                    
                    s = reg.stringByReplacingMatchesInString(s, options: .allZeros, range: NSMakeRange(0, s.utf16Count), withTemplate: "")
                    
                    break
                }
                
                if !match {
                    ///!!!! ERROR !!!!!
                }
                
                
            }
            s = s.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        }
    }
    
    func getTokens() -> Array<Token> {
        return tokens
    }
}
