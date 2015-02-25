//
//  FunctionExpression.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation
class FunctionExpression: ExpressionProtocol {
    
    var function:Int
    var argument:ExpressionProtocol
    
    init(function:Int, argument:ExpressionProtocol){
        self.function = function
        self.argument = argument
    }
    
    func getType() -> Int {
        return Expression.function.rawValue
    }
    
    func getValue() -> Double? {
        let arg:Double = argument.getValue()!
        switch function {
            case FunctionNode.sin.rawValue : return sin(arg)
            case FunctionNode.cos.rawValue : return cos(arg)
            case FunctionNode.tan.rawValue : return tan(arg)
            
            case FunctionNode.asin.rawValue : return asin(arg)
            case FunctionNode.acos.rawValue : return acos(arg)
            case FunctionNode.atan.rawValue : return atan(arg)
            
            case FunctionNode.sqrt.rawValue : return sqrt(arg)
            case FunctionNode.exp.rawValue : return exp(arg)
            
            case FunctionNode.ln.rawValue : return log(arg)
            case FunctionNode.log.rawValue : return log10(arg)
            case FunctionNode.log2.rawValue : return log2(arg)
            
            default : return 0 // !!!!ERROR!!!
        }
    }
    
    class func stringToFunction(str:String) -> Int {
        switch str {
            case "sin" : return FunctionNode.sin.rawValue
            case "cos" : return FunctionNode.cos.rawValue
            case "tan" : return FunctionNode.tan.rawValue
            
            case "asin" : return FunctionNode.asin.rawValue
            case "acos" : return FunctionNode.acos.rawValue
            case "atan" : return FunctionNode.atan.rawValue
            
            case "sqrt" : return FunctionNode.sqrt.rawValue
            case "exp" : return FunctionNode.exp.rawValue
            
            case "ln" : return FunctionNode.ln.rawValue
            case "log" : return FunctionNode.log.rawValue
            case "log2" : return FunctionNode.log2.rawValue
            
            default: return -1
        }
    }
    
    class func getAllFunctions() -> String {
        return "sin|cos|tan|asin|acos|atan|sqrt|exp|ln|log|log2";
    }
    
    func accept(visitor:ExpressionVisitor){
        visitor.visit(self)
        argument.accept(visitor)
        
    }
    
}