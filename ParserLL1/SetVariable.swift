//
//  SetVariable.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 22.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class SetVariable: ExpressionNodeVisitor {
    private var name:String
    private var value:Double
    
    init(name:String, value:Double){
        self.name = name
        self.value = value
    }
    
    func visit(node:VariableExpressionNode){
        if node.getName() == name {
            node.setValue(value)
        }
    }
    
    func visit(ConstantExpressionNode){
        
    }
    
    func visit(AdditionExpressionNode){
        
    }
    
    func visit(MultiplicationExpressionNode){
        
    }
    
    func visit(ExponentiationExpressionNode){
        
    }
    
    func visit(FunctionExpressionNode){
        
    }
}