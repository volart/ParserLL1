//
//  AdditionExpressionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class AdditionExpressionNode: SequenceExpressionNode, ExpressionNodeProtocol {
    override init(){
        super.init()
    }
    
    override init(exp: ExpressionNodeProtocol, positive:Bool){
        super.init(exp: exp, positive:positive)
    }
    
    func getType() -> Int {
        return ExpressionNode.addition.rawValue
    }
    
    func getValue() -> Double {
        var sum:Double = 0.0;
        for term in terms {
            if term.positive {
                sum += term.expression.getValue()
            } else {
                sum -= term.expression.getValue()
            }
        }
        return sum
    }
    
    func accept(visitor:ExpressionNodeVisitor){
        visitor.visit(self)
        for term in terms {
            term.expression.accept(visitor)
        }
    }
}