//
//  Parser.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

// Here is realized LL(1) grammar parser and calculated math expression.
class Parser {
    var tokens: Array<Token>
    var lookahead: Token
    
    init(){
        tokens = []
        lookahead = Token()
    }
    
    private func parse(str:String?) -> (expression: ExpressionProtocol?, message: String?) {
        
        var tokenizer:Tokenizer = Tokenizer.getExpressionTokenizer()
        tokenizer.tokenize(str!)
        var tokens:Array<Token> = tokenizer.getTokens()
        if tokens.capacity == 0 {
            let mes:String = "Please, you have to write something in arguments. Something like: 29 + 13"
            return (nil, mes)
        }
        return parse(tokens)
    }
    
    func parseMain(str:String?) -> (result: Double?, message: String?) {
        let p = parse(str)
        let e = p.expression
        if e == nil {
            return (nil, p.message!)
        }
        if let v = e?.getValue() {
            return (v, nil)
        } else {
            let mes =  "Unknown constant"
            return (nil, mes)
        }
    }
    
    private func parse(tokens: Array<Token>) -> (expression: ExpressionProtocol?, message: String?) {
        var mes:String?
        self.tokens = tokens
        lookahead = self.tokens.first!
        
        var expr = expression()
        if expr.expression == nil {
            return expr
        }
        
        if lookahead.token != Token.epsilon {
            mes =  "Unexpected symbol found"
            return (nil, mes)
        }
        
        setVariable(expr.expression!)
        return (expr.expression, nil)
    }
    
    private func nextToken(){
        tokens.removeAtIndex(0)
        
        if tokens.isEmpty {
            // epsilon token means end
            lookahead = Token(token: Token.epsilon, sequence: "", pos: -1)
        } else {
            lookahead = tokens.first!
        }
    }
    
    private func expression() -> (expression: ExpressionProtocol?, message: String?) {
        var exp = signedTerm()
        
        if exp.expression == nil {
            return exp
        }
        return sumOp(exp.expression, message: nil)
    }
    
    private func sumOp(expression: ExpressionProtocol?, message: String?) -> (expression: ExpressionProtocol?, message: String?) {
        
        if expression == nil {
            return (expression, message)
        }
        
        if lookahead.token == Token.plusminus {
            var sum:AdditionExpression
            if expression!.getType() == Expression.addition.rawValue {
                sum = expression! as AdditionExpression
            } else {
                sum = AdditionExpression(exp: expression!, positive: true)
            }
            let isPositive:Bool = lookahead.sequence == "+"
            nextToken()
            
            let t =  term()
            if t.expression == nil {
                return t
            }
            sum.add(t.expression!, positive: isPositive)
            return sumOp(sum, message: nil)
        }

        return (expression, message)
    }
    
    private func signedTerm() -> (expression: ExpressionProtocol?, message: String?) {

        if lookahead.token == Token.plusminus {
            let isPositive:Bool = lookahead.sequence == "+"
            nextToken()
            var t = term()
            if t.expression == nil {
                return t
            }
            if isPositive {
                return (t.expression, nil)
            } else {
                return (AdditionExpression(exp: t.expression!, positive: isPositive), nil)
            }
        } else {
            return term()
        }
    }
    
    private func term() -> (expression: ExpressionProtocol?, message: String?){
        var f = factor()
        if f.expression == nil {
            return f
        }
        return termOp(f.expression!, message: nil)
    }
    
    private func termOp(expression: ExpressionProtocol?, message: String?) -> (expression: ExpressionProtocol?, message: String?){
        
        if expression == nil {
            return (expression, message)
        }
        
        if lookahead.token == Token.multdiv {
            var prod:MultiplicationExpression
            if expression!.getType() == Expression.multiplication.rawValue {
                prod = expression as MultiplicationExpression
            } else {
                prod = MultiplicationExpression(exp: expression!, positive: true)
            }
            
            let isPositive:Bool = lookahead.sequence == "*"
            nextToken()
            var f = signedFactor()
            if f.expression == nil {
                return f
            }
            prod.add(f.expression!, positive: isPositive)
            
            return termOp(prod, message: nil)
        } else {
            return (expression, message)
        }
    }
    
    private func signedFactor() -> (expression: ExpressionProtocol?, message: String?){
        if lookahead.token == Token.plusminus {
            var isPositive:Bool = lookahead.sequence == "+"
            nextToken()
            var t = factor()
            if t.expression == nil {
                return t
            }
            if isPositive {
                return (t.expression, nil)
            }
            return (AdditionExpression(exp: t.expression!, positive: isPositive), nil)
        }
            return factor()
    }
    
    private func factor()-> (expression: ExpressionProtocol?, message: String?) {
        var a = argument()
        if a.expression == nil {
            return a
        }
        return factorOp(a.expression!, message: a.message)
    }
    
    private func factorOp(expression: ExpressionProtocol?, message: String?) -> (expression: ExpressionProtocol?, message: String?) {
        
        if lookahead.token == Token.raised {
            nextToken()
            var exponent = signedFactor()
            if exponent.expression == nil {
                return exponent
            }
            return (ExponentiationExpression(base: expression!, exponent: exponent.expression!), nil)
        } else {
            return (expression, message)
        }
    }
    
    private func argument() -> (expression: ExpressionProtocol?, message: String?) {
        let seq = lookahead.sequence
        var expr:(expression: ExpressionProtocol?, message: String?)
        switch lookahead.token  {
            case Token.function :
                let function:Int = FunctionExpression.stringToFunction(seq)
                nextToken()
                expr = argument()
                if expr.expression == nil {
                    return expr
                }
                return (FunctionExpression(function: function, argument: expr.expression!), nil)
            case Token.openBracket :
                nextToken()
                expr = expression()
            
                if lookahead.token != Token.clouseBracket {
                    let mes: String = "Closing brackets are expected but it isn't"
                    return (nil, mes)
                }
            
                nextToken()
                return expr
            default :
                return value()
            }
        
    }
    
    private func value() -> (expression: ExpressionProtocol?, message: String?) {
        var expr:ExpressionProtocol?
        let seq = lookahead.sequence
        
        switch lookahead.token {
            case Token.number:
                expr = ConstantExpression(value: seq)
                nextToken();
            case Token.variable:
                expr = VariableExpression(name: seq)
                nextToken();
            default:
                let mes: String = "Unexpected symbol found"
                return (nil, mes)
        }
        
        return (expr!, nil)
    }
    
    private func setVariable(expression: ExpressionProtocol) {
        let π = M_PI
        let e = 2.71828
        expression.accept(Variable(name: "PI", value: π))
        expression.accept(Variable(name: "E", value: e))
    }
}