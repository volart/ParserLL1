//
//  MultiplicationExpressionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class MultiplicationExpressionNode: SequenceExpressionNode, ExpressionNodeProtocol {
    override init(){
        super.init()
    }
    
    override init(exp: ExpressionNodeProtocol, positive:Bool){
        super.init(exp: exp, positive:positive)
    }
    
    func getType() -> Int {
        return ExpressionNode.multiplication.rawValue
    }
    
    func getValue() -> Double {
        var prod:Double = 1.0;
        for term in terms {
            if term.positive {
                prod *= term.expression.getValue()
            } else {
                prod /= term.expression.getValue()
            }
        }
        return prod
    }
    
    func accept(visitor:ExpressionNodeVisitor){
        visitor.visit(self)
        for term in terms {
            term.expression.accept(visitor)
        }
    }
}