//
//  Token.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

public struct Token {
    
    static let epsilon:Int = 0
    static let plusminus:Int = 1
    static let multdiv:Int = 2
    static let raised:Int = 3
    static let function:Int = 4
    static let openBracket:Int = 5
    static let clouseBracket:Int = 6
    static let number:Int = 7
    static let variable:Int = 8
    
    var token: Int
    var sequence: String
    var pos: Int
    init(token: Int, sequence: String, pos: Int){
        self.token = token
        self.sequence = sequence
        self.pos = pos
    }
    
    init(){
        token = 0
        sequence = ""
        pos = -1
    }
}