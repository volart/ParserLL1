//
//  AdditionExpression.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class AdditionExpression: SequenceExpression, ExpressionProtocol {
    override init(){
        super.init()
    }
    
    override init(exp: ExpressionProtocol, positive:Bool){
        super.init(exp: exp, positive:positive)
    }
    
    func getType() -> Int {
        return Expression.addition.rawValue
    }
    
    func getValue() -> Double? {
        var sum:Double = 0.0;
        for term in terms {
            if var v = term.expression.getValue()? {
                if term.positive {
                    sum += v
                } else {
                    sum -= v
                }
            } else {
                return nil
            }
        }
        return sum
    }
    
    func accept(visitor:ExpressionVisitor){
        visitor.visit(self)
        for term in terms {
            term.expression.accept(visitor)
        }
    }
}