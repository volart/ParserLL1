//
//  MultiplicationExpression.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class MultiplicationExpression: SequenceExpression, ExpressionProtocol {
    override init(){
        super.init()
    }
    
    override init(exp: ExpressionProtocol, positive:Bool){
        super.init(exp: exp, positive:positive)
    }
    
    func getType() -> Int {
        return Expression.multiplication.rawValue
    }
    
    func getValue() -> Double? {
        var prod:Double = 1.0;
        for term in terms {
            if term.positive {
                prod *= term.expression.getValue()!
            } else {
                prod /= term.expression.getValue()!
            }
        }
        return prod
    }
    
    func accept(visitor:ExpressionVisitor){
        visitor.visit(self)
        for term in terms {
            term.expression.accept(visitor)
        }
    }
}