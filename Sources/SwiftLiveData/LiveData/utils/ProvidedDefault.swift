//
//  ProvidedDefault.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public extension LiveDataUtils {
    class ProvidedDefault<T: MutableLiveData,Value>: MutableLiveData where T.Value == Value? {
        private let source: T
        private let defaultValue: Value
        init(_ source: T, defaultValue: Value) {
            self.source = source
            self.defaultValue = defaultValue
        }
        
        public func get() -> Value {
            source.get() ?? defaultValue
        }
        
        public func set(_ value: Value) {
            source.set(value)
        }
        
        public func publisher() -> AnyPublisher<Value, Never> {
            source.publisher().replaceNil(with: defaultValue).eraseToAnyPublisher()
        }
    }
    
    struct DefaultMapper<T>: ValueMapper {
        public typealias X = T?
        public typealias Y = T
        
        private let defaultValue: T
        
        public init(_ defaultValue: T) {
            self.defaultValue = defaultValue
        }
        
        public func map(_ value: T?) -> T {
            value ?? defaultValue
        }
        
        public func map(_ value: T) -> T? {
            return value
        }
    }
}


