//
//  AnyLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public struct AnyLiveData<Value>: CustomStringConvertible, LiveData {

    private let wrappedGet: () -> Value
    private let getPublisher: () -> AnyPublisher<Value, Never>

    public var description: String {
        return "LiveData with Value: \(self.get())"
    }

    public init<D>(_ source: D) where Value == D.Value, D: LiveData {
        self.wrappedGet = source.get
        self.getPublisher = source.publisher
    }

    public func get() -> Value {
        self.wrappedGet()
    }
    
    public func publisher() -> AnyPublisher<Value, Never> {
        self.getPublisher()
    }
}
