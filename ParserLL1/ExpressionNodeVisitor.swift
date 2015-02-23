//
//  ExpressionNodeVisitor.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 22.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

protocol ExpressionNodeVisitor {
    func visit(VariableExpressionNode)
    func visit(ConstantExpressionNode)
    func visit(AdditionExpressionNode)
    func visit(MultiplicationExpressionNode)
    func visit(ExponentiationExpressionNode)
    func visit(FunctionExpressionNode)
}