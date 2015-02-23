//
//  ExpressionNodeProtocol.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

protocol ExpressionNodeProtocol {
    func getType() -> Int
    func getValue() -> Double
    func accept(visitor:ExpressionNodeVisitor)
}