//
//  SimpleValueMapper.swift
//  
//
//  Created by Hannes Harnisch on 07.12.22.
//

import Foundation


public class SimpleValueMapper<X,Y>: ValueMapper {
    public typealias X = X
    public typealias Y = Y
    
    private var wrappedMap: (X) -> (Y)
    private var wrappedRevMap: (Y) -> (X)
    
    public init(_ map: @escaping (X) -> Y, rev: @escaping (Y) -> (X)) {
        self.wrappedMap = map
        self.wrappedRevMap = rev
    }
    
    public func map(_ value: X) -> Y {
        wrappedMap(value)
    }
    
    public func map(_ value: Y) -> X {
        wrappedRevMap(value)
    }
}
