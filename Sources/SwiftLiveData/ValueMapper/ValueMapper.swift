//
//  ValueMapper.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation

protocol ValueMapper {
    associatedtype X
    associatedtype Y
    
    func map(_ value: X) -> Y
    
    func map(_ value: Y) -> X
}
