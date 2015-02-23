//
//  ExpressionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

enum ExpressionNode: Int {
    case error = 0
    case variable = 1
    case constant = 2
    case addition = 3
    case multiplication = 4
    case exponentiation = 5
    case function = 6
}