//
//  main.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

var par:Parser = Parser()

let expr = par.parse("  11 + (exp(2.010635 + sin(PI/2) * 3) + 50) / 2 ")
if expr.expression != nil {
    println("The value of the expression is  \(expr.expression!.getValue())")
} else {
    println(expr.message)
}


