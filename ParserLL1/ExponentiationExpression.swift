//
//  ExponentiationExpression.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class ExponentiationExpression: ExpressionProtocol {
    var base:ExpressionProtocol
    var exponent:ExpressionProtocol
    
    init(base:ExpressionProtocol, exponent:ExpressionProtocol){
        self.base = base
        self.exponent = exponent
    }

    func getType() -> Int {
        return Expression.exponentiation.rawValue;
    }
    
    func getValue() -> Double? {
        return pow(base.getValue()!, exponent.getValue()!)
    }
    
    func accept(visitor:ExpressionVisitor){
        visitor.visit(self)
        base.accept(visitor)
        exponent.accept(visitor)
    }
}