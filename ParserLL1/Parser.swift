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
    
    func parse(str:String) -> (exprNode: ExpressionNodeProtocol?, message: String?) {
        
        var tokenizer:Tokenizer = Tokenizer.getExpressionTokenizer()
        tokenizer.tokenize(str)
        var tokens:Array<Token> = tokenizer.getTokens()
        if tokens.capacity == 0 {
            let mes:String = "Please, you have to write something in arguments. Something like: 29 + 13"
            return (nil, mes)
        }
        return parse(tokens)
    }
    
    private func parse(tokens: Array<Token>) -> (exprNode: ExpressionNodeProtocol?, message: String?) {
        self.tokens = tokens
        lookahead = self.tokens.first!
        
        var expr:ExpressionNodeProtocol = expression()
        
        
        if lookahead.token != Token.epsilon {
            let mes:String =  "Unexpected symbol found"
            return (nil, mes)
        }
        
        return (expr, nil)
    }
    
    func nextToken(){
        tokens.removeAtIndex(0)
        
        if tokens.isEmpty {
            lookahead = Token(token: Token.epsilon, sequence: "", pos: -1)
        } else {
            lookahead = tokens.first!
        }
    }
    
    func expression() -> ExpressionNodeProtocol {
        var exp:ExpressionNodeProtocol = signedTerm()
        return sumOp(exp)
    }
    
    func sumOp(exp:ExpressionNodeProtocol) -> ExpressionNodeProtocol {
        // sum_op -> PLUSMINUS term sum_op
        if lookahead.token == Token.plusminus {
            var sum:AdditionExpressionNode
            if exp.getType() == ExpressionNode.addition.rawValue {
                sum = exp as AdditionExpressionNode
            } else {
                sum = AdditionExpressionNode(exp: exp, positive: true)
            }
            var isPositive:Bool = lookahead.sequence == "+"
            nextToken()
            
            var t:ExpressionNodeProtocol =  term()
            sum.add(t, positive: isPositive)
            return sumOp(sum)
        }
        // sum_op -> EPSILON
        return exp
    }
    
    func signedTerm() -> ExpressionNodeProtocol {
        // signed_term -> PLUSMINUS term
        if lookahead.token == Token.plusminus {
            let isPositive:Bool = lookahead.sequence == "+"
            
            nextToken()
            var t:ExpressionNodeProtocol = term()
            if isPositive {
                return t
            } else {
                return AdditionExpressionNode(exp: t, positive: isPositive)
            }
        } else {
            // signed_term -> term
            return term()
        }
    }
    
    func term() -> ExpressionNodeProtocol{
        // term -> factor term_op
        var f:ExpressionNodeProtocol = factor()
        return termOp(f)
    }
    
    func termOp(expression: ExpressionNodeProtocol) -> ExpressionNodeProtocol{
        // term_op -> MULTDIV factor term_op
        if lookahead.token == Token.multdiv {
            var prod:MultiplicationExpressionNode
            if expression.getType() == ExpressionNode.multiplication.rawValue {
                prod = expression as MultiplicationExpressionNode
            } else {
                prod = MultiplicationExpressionNode(exp: expression, positive: true)
            }
            
            let isPositive:Bool = lookahead.sequence == "*"
            nextToken()
            var f:ExpressionNodeProtocol = signedFactor()
            prod.add(f, positive: isPositive)
            
            return termOp(prod)
        } else {
            // term_op -> EPSILON
            return expression
        }
    }
    
    func signedFactor() -> ExpressionNodeProtocol{
        // signed_factor -> PLUSMINUS factor
        if lookahead.token == Token.plusminus {
            var isPositive:Bool = lookahead.sequence == "+"
            nextToken()
            var t:ExpressionNodeProtocol = factor()
            if isPositive {
                return t
            }
            return AdditionExpressionNode(exp: t, positive: isPositive)
        }
            // signed_factor -> factor
            return factor()
        
    }
    
    func factor()-> ExpressionNodeProtocol{
        // factor -> argument factor_op
        var a:ExpressionNodeProtocol = argument()
        return factorOp(a)
    }
    
    func factorOp(expression: ExpressionNodeProtocol) -> ExpressionNodeProtocol{
        if lookahead.token == Token.raised {
            // factor_op -> RAISED expression
            nextToken()
            var exponent:ExpressionNodeProtocol = signedFactor()
            return ExponentiationExpressionNode(base: expression, exponent: exponent)
        } else {
            // factor_op -> EPSILON
            return expression
        }
    }
    
    func argument() -> ExpressionNodeProtocol{
        let seq = lookahead.sequence
        var expr:ExpressionNodeProtocol
        if lookahead.token == Token.function {
            // argument -> FUNCTION argument
            let function:Int = FunctionExpressionNode.stringToFunction(seq)
            nextToken()
            expr = argument()
            return FunctionExpressionNode(function: function, argument: expr)
        } else if lookahead.token == Token.openBracket {
            // argument -> OPEN_BRACKET sum CLOSE_BRACKET
            nextToken()
            expr = expression()
            
            if lookahead.token != Token.clouseBracket{
                //!!!!!ERROR!!! Closing brackets are expected but it isn't.
            }
            
            nextToken()
            return expr
        } else {
            // argument -> value
            return value()
        }
    }
    
    func value() -> ExpressionNodeProtocol {
        var expr:ExpressionNodeProtocol?
        let seq = lookahead.sequence
        if lookahead.token == Token.number {
            // argument -> NUMBER
            expr = ConstantExpressionNode(value: seq)
            nextToken();
        } else if lookahead.token == Token.variable {
            // argument -> VARIABLE
            expr = VariableExpressionNode(name: seq)
            nextToken();
        } else {
            //!!!!!ERROR!!! Unexpected symbol
            
        }
        
        return expr!
    }
}