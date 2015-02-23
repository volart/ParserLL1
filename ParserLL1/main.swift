//
//  main.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

var par:Parser = Parser()

let expr = par.parse("    ")
if expr.exprNode != nil {
    let π = M_PI
    expr.exprNode!.accept(SetVariable(name: "PI", value: π))
    println("The value of the expression is  \(expr.exprNode!.getValue())")
} else {
    println(expr.message)
}


