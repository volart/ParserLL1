//
//  SetVariable.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 22.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class Variable: ExpressionVisitor {
    private var name:String
    private var value:Double
    
    init(name:String, value:Double){
        self.name = name
        self.value = value
    }
    
    func visit(node:VariableExpression){
        if node.getName() == name {
            node.setValue(value)
        }
    }
    
    func visit(ConstantExpression){
        
    }
    
    func visit(AdditionExpression){
        
    }
    
    func visit(MultiplicationExpression){
        
    }
    
    func visit(ExponentiationExpression){
        
    }
    
    func visit(FunctionExpression){
        
    }
}