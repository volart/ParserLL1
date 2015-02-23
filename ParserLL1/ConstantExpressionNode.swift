//
//  ConstantExpressionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class ConstantExpressionNode: ExpressionNodeProtocol {
    private var value:Double
 
    init(value:Double){
        self.value = value
    }
    
    init(value:String){
        self.value = (value as NSString).doubleValue
    }
    
    func getType() -> Int{
        return ExpressionNode.constant.rawValue
    }
    
    func getValue() -> Double{
        return value
    }
    
    func accept(visitor:ExpressionNodeVisitor){
        visitor.visit(self)
    }
}