//
//  ExpressionVisitor.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 22.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation


// Visitor pattern
protocol ExpressionVisitor {
    func visit(VariableExpression)
    func visit(ConstantExpression)
    func visit(AdditionExpression)
    func visit(MultiplicationExpression)
    func visit(ExponentiationExpression)
    func visit(FunctionExpression)
}