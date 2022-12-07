//
//  MutableLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public protocol MutableLiveData {
    associatedtype Value
    
    func get() -> Value
    func set(_ value: Value)
    func publisher() -> AnyPublisher<Value, Never>
}

extension MutableLiveData {
    func eraseToAnyMutableLiveData() -> AnyMutableLiveData<Value> {
        AnyMutableLiveData(self)
    }
    
    func toLiveData() -> LiveDataUtils.LiveDataWrapper<Self> {
        LiveDataUtils.LiveDataWrapper(self)
    }
    
    func replaceNil<T>(with defaultValue: T) -> MappedMutableLiveData<LiveDataUtils.DefaultMapper<T>> where T? == Value {
        self.map(LiveDataUtils.DefaultMapper(defaultValue))
    }
}
