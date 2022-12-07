//
//  AnyLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

struct AnyLiveData<Value>: CustomStringConvertible, LiveData {

    private let wrappedGet: () -> Value
    private let getPublisher: () -> AnyPublisher<Value, Never>

    var description: String {
        return "LiveData with Value: \(self.get())"
    }

    init<D>(_ source: D) where Value == D.Value, D: LiveData {
        self.wrappedGet = source.get
        self.getPublisher = source.publisher
    }

    func get() -> Value {
        self.wrappedGet()
    }
    
    func publisher() -> AnyPublisher<Value, Never> {
        self.getPublisher()
    }
}
