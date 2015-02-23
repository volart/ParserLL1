//
//  ExponentiationExpressionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class ExponentiationExpressionNode: ExpressionNodeProtocol {
    var base:ExpressionNodeProtocol
    var exponent:ExpressionNodeProtocol
    
    init(base:ExpressionNodeProtocol, exponent:ExpressionNodeProtocol){
        self.base = base
        self.exponent = exponent
    }

    func getType() -> Int {
        return ExpressionNode.exponentiation.rawValue;
    }
    
    func getValue() -> Double {
        return pow(base.getValue(),exponent.getValue())
    }
    
    func accept(visitor:ExpressionNodeVisitor){
        visitor.visit(self)
        base.accept(visitor)
        exponent.accept(visitor)
    }
}