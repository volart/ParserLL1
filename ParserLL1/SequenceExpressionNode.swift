//
//  SequenceExpressionNode.swift
//  ParserLL1
//
//  Created by Artoym Volobuev on 20.02.15.
//  Copyright (c) 2015 Artoym Volobuev. All rights reserved.
//

import Foundation

class SequenceExpressionNode {
    
    class Term {
        var positive:Bool
        var expression:ExpressionNodeProtocol
        
        init(positive:Bool, expression:ExpressionNodeProtocol){
            self.positive = positive
            self.expression = expression
        }
    }
    
    var terms:Array<Term>
    
    init(){
        terms = Array<Term>()
    }
    
    init(exp: ExpressionNodeProtocol, positive:Bool){
        terms = Array<Term>()
        terms.append(Term(positive:positive, expression:exp))
    }
    
    func add(exp: ExpressionNodeProtocol, positive:Bool){
        terms.append(Term(positive:positive, expression:exp))
    }
    
}