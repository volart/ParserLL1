//
//  Parser.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class Parser {
    var tokens: Array<Token>
    var lookahead: Token
    
    init(){
        tokens = []
        lookahead = Token()
    }
    
    func parse(str:String) -> (expression: ExpressionNodeProtocol?, message: String?) {
        
        var tokenizer:Tokenizer = Tokenizer.getExpressionTokenizer()
        tokenizer.tokenize(str)
        var tokens:Array<Token> = tokenizer.getTokens()
        if tokens.capacity == 0 {
            let mes:String = "Please, you have to write something in arguments. Something like: 29 + 13"
            return (nil, mes)
        }
        return parse(tokens)
    }
    
    private func parse(tokens: Array<Token>) -> (expression: ExpressionNodeProtocol?, message: String?) {
        self.tokens = tokens
        lookahead = self.tokens.first!
        
        var expr = expression()
        
        if expr.expression == nil {
            return expr
        }
        
        if lookahead.token != Token.epsilon {
            let mes:String =  "Unexpected symbol found"
            return (nil, mes)
        }
        
        setVariable(expr.expression!)
            
        return (expr.expression, nil)
    }
    
    func nextToken(){
        tokens.removeAtIndex(0)
        
        if tokens.isEmpty {
            lookahead = Token(token: Token.epsilon, sequence: "", pos: -1)
        } else {
            lookahead = tokens.first!
        }
    }
    
    func expression() -> (expression: ExpressionNodeProtocol?, message: String?) {
        var exp = signedTerm()
        if exp.expression == nil {
            return exp
        }
        return sumOp(exp.expression, message: nil)
    }
    
    func sumOp(expression: ExpressionNodeProtocol?, message: String?) -> (expression: ExpressionNodeProtocol?, message: String?) {
        if expression == nil {
            return (expression, message)
        }
        // sum_op -> PLUSMINUS term sum_op
        if lookahead.token == Token.plusminus {
            var sum:AdditionExpressionNode
            if expression!.getType() == ExpressionNode.addition.rawValue {
                sum = expression as AdditionExpressionNode
            } else {
                sum = AdditionExpressionNode(exp: expression!, positive: true)
            }
            var isPositive:Bool = lookahead.sequence == "+"
            nextToken()
            
            var t =  term()
            if t.expression == nil {
                return t
            }
            sum.add(t.expression!, positive: isPositive)
            return sumOp(sum, message: nil)
        }
        // sum_op -> EPSILON
        return (expression, message)
    }
    
    func signedTerm() -> (expression: ExpressionNodeProtocol?, message: String?) {
        // signed_term -> PLUSMINUS term
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
                return (AdditionExpressionNode(exp: t.expression!, positive: isPositive), nil)
            }
        } else {
            // signed_term -> term
            return term()
        }
    }
    
    func term() -> (expression: ExpressionNodeProtocol?, message: String?){
        // term -> factor term_op
        var f = factor()
        if f.expression == nil {
            return f
        }
        return termOp(f.expression!, message: nil)
    }
    
    func termOp(expression: ExpressionNodeProtocol?, message: String?) -> (expression: ExpressionNodeProtocol?, message: String?){
        
        if expression == nil {
            return (expression, message)
        }
        
        // term_op -> MULTDIV factor term_op
        if lookahead.token == Token.multdiv {
            var prod:MultiplicationExpressionNode
            if expression!.getType() == ExpressionNode.multiplication.rawValue {
                prod = expression as MultiplicationExpressionNode
            } else {
                prod = MultiplicationExpressionNode(exp: expression!, positive: true)
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
            // term_op -> EPSILON
            return (expression, message)
        }
    }
    
    func signedFactor() -> (expression: ExpressionNodeProtocol?, message: String?){
        // signed_factor -> PLUSMINUS factor
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
            return (AdditionExpressionNode(exp: t.expression!, positive: isPositive), nil)
        }
            // signed_factor -> factor
            return factor()
    }
    
    func factor()-> (expression: ExpressionNodeProtocol?, message: String?) {
        // factor -> argument factor_op
        var a = argument()
        if a.expression == nil {
            return a
        }
        return factorOp(a.expression!, message: a.message)
    }
    
    func factorOp(expression: ExpressionNodeProtocol?, message: String?) -> (expression: ExpressionNodeProtocol?, message: String?) {
        
        if lookahead.token == Token.raised {
            // factor_op -> RAISED expression
            nextToken()
            var exponent = signedFactor()
            if exponent.expression == nil {
                return exponent
            }
            return (ExponentiationExpressionNode(base: expression!, exponent: exponent.expression!), nil)
        } else {
            // factor_op -> EPSILON
            return (expression, message)
        }
    }
    
    func argument() -> (expression: ExpressionNodeProtocol?, message: String?) {
        let seq = lookahead.sequence
        var expr:(expression: ExpressionNodeProtocol?, message: String?)
        switch lookahead.token  {
            case Token.function :
                // argument -> FUNCTION argument
                let function:Int = FunctionExpressionNode.stringToFunction(seq)
                nextToken()
                expr = argument()
                if expr.expression == nil {
                    return expr
                }
                return (FunctionExpressionNode(function: function, argument: expr.expression!), nil)
            case Token.openBracket :
                // argument -> OPEN_BRACKET sum CLOSE_BRACKET
                nextToken()
                expr = expression()
            
                if lookahead.token != Token.clouseBracket {
                    let mes: String = "Closing brackets are expected but it isn't"
                    return (nil, mes)
                }
            
                nextToken()
                return expr
            default :
                // argument -> value
                return value()
            }
        
    }
    
    func value() -> (expression: ExpressionNodeProtocol?, message: String?) {
        var expr:ExpressionNodeProtocol?
        let seq = lookahead.sequence
        
        switch lookahead.token {
            case Token.number:
                expr = ConstantExpressionNode(value: seq)
                nextToken();
            case Token.variable:
                expr = VariableExpressionNode(name: seq)
                nextToken();
            default:
                let mes: String = "Unexpected symbol found"
                return (nil, mes)
        }
        
        return (expr!, nil)
    }
    
    func setVariable(expression: ExpressionNodeProtocol) {
        let π = M_PI
        let e = 2.71828
        expression.accept(SetVariable(name: "PI", value: π))
        expression.accept(SetVariable(name: "E", value: e))
    }
}