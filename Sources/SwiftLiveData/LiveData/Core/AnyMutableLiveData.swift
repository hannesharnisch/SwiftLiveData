//
//  AnyMutableLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

struct AnyMutableLiveData<Value>: CustomStringConvertible, MutableLiveData {
    
    private let wrappedSet: (Value) -> ()
    private let wrappedGet: () -> Value
    private let getPublisher: () -> AnyPublisher<Value, Never>

    var description: String {
        return "MutableLiveData with Value: \(self.get())"
    }

    init<D>(_ source: D) where Value == D.Value, D: MutableLiveData {
        self.wrappedSet = source.set
        self.wrappedGet = source.get
        self.getPublisher = source.publisher
    }

    func get() -> Value {
        self.wrappedGet()
    }
    
    func set(_ value: Value) {
        self.wrappedSet(value)
    }
    
    func publisher() -> AnyPublisher<Value, Never> {
        self.getPublisher()
    }
}
