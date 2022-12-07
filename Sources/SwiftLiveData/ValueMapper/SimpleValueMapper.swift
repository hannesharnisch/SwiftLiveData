//
//  SimpleValueMapper.swift
//  
//
//  Created by Hannes Harnisch on 07.12.22.
//

import Foundation


class SimpleValueMapper<X,Y>: ValueMapper {
    typealias X = X
    typealias Y = Y
    
    private var wrappedMap: (X) -> (Y)
    private var wrappedRevMap: (Y) -> (X)
    
    init(_ map: @escaping (X) -> Y, rev: @escaping (Y) -> (X)) {
        self.wrappedMap = map
        self.wrappedRevMap = rev
    }
    
    func map(_ value: X) -> Y {
        wrappedMap(value)
    }
    
    func map(_ value: Y) -> X {
        wrappedRevMap(value)
    }
}
