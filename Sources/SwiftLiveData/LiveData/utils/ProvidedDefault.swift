//
//  ProvidedDefault.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

extension LiveDataUtils {
    class ProvidedDefault<T: MutableLiveData,Value>: MutableLiveData where T.Value == Value? {
        private let source: T
        private let defaultValue: Value
        init(_ source: T, defaultValue: Value) {
            self.source = source
            self.defaultValue = defaultValue
        }
        
        func get() -> Value {
            source.get() ?? defaultValue
        }
        
        func set(_ value: Value) {
            source.set(value)
        }
        
        func publisher() -> AnyPublisher<Value, Never> {
            source.publisher().replaceNil(with: defaultValue).eraseToAnyPublisher()
        }
    }
    
    struct DefaultMapper<T>: ValueMapper {
        typealias X = T?
        typealias Y = T
        
        private let defaultValue: T
        
        init(_ defaultValue: T) {
            self.defaultValue = defaultValue
        }
        func map(_ value: T?) -> T {
            value ?? defaultValue
        }
        
        func map(_ value: T) -> T? {
            return value
        }
    }
}


