//
//  VariableExpressionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class VariableExpressionNode: ExpressionNodeProtocol {
    private var name:String
    private var value:Double?

    
    init(name:String){
        self.name = name
    }
    
    func getType() -> Int {
        return ExpressionNode.variable.rawValue
    }
    
    func getName() -> String {
        return name
    }
    
    func setValue(value:Double){
        self.value = value

    }
    
    func getValue() -> Double {
        return value!  
    }
    
    func accept(visitor:ExpressionNodeVisitor){
        visitor.visit(self)
    }
}