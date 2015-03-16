//
//  FunctionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

enum FunctionNode: Int {
    case sin = 1
    case cos = 2
    case tan = 3

    case asin = 4
    case acos = 5
    case atan = 6

    case sqrt = 7
    case exp = 8

    case ln = 9
    case log = 10
    case log2 = 11
}