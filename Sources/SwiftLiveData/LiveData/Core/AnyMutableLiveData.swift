//
//  AnyMutableLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public struct AnyMutableLiveData<Value>: CustomStringConvertible, MutableLiveData {
    
    private let wrappedSet: (Value) -> ()
    private let wrappedGet: () -> Value
    private let getPublisher: () -> AnyPublisher<Value, Never>

    public var description: String {
        return "MutableLiveData with Value: \(self.get())"
    }

    public init<D>(_ source: D) where Value == D.Value, D: MutableLiveData {
        self.wrappedSet = source.set
        self.wrappedGet = source.get
        self.getPublisher = source.publisher
    }

    public func get() -> Value {
        self.wrappedGet()
    }
    
    public func set(_ value: Value) {
        self.wrappedSet(value)
    }
    
    public func publisher() -> AnyPublisher<Value, Never> {
        self.getPublisher()
    }
}
