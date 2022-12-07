//
//  LiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public protocol LiveData {
    associatedtype Value
    
    func get() -> Value
    func publisher() -> AnyPublisher<Value, Never>
}

public extension LiveData {
    func eraseToAnyLiveData() -> AnyLiveData<Value> {
        return AnyLiveData(self)
    }
    
    func replaceNil<T>(with defaultValue: T) -> MappedLiveData<Value,T> where T? == Value {
        self.map { value in
            return value ?? defaultValue
        }
    }
}

