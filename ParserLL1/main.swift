//
//  main.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

var par:Parser = Parser()
let expr = par.parseMain(" 5+5*3 + 1")
if expr.result != nil {
    println(expr.result!)
} else {
    println("ERROR: " + expr.message!)
}


