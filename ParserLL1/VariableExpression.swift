//
//  VariableExpression.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class VariableExpression: ExpressionProtocol {
    private var name:String
    private var value:Double?

    
    init(name:String){
        self.name = name
    }
    
    func getType() -> Int {
        return Expression.variable.rawValue
    }
    
    func getName() -> String {
        return name
    }
    
    func setValue(value:Double){
        self.value = value

    }
    
    func getValue() -> Double? {
        return value?
    }
    
    func accept(visitor:ExpressionVisitor){
        visitor.visit(self)
    }
}