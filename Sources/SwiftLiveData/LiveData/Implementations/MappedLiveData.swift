//
//  MappedLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public class MappedLiveData<X,Y>: LiveData {
    
    private let source: AnyLiveData<X>
    private let map: (X) -> (Y)

    init<S: LiveData>(_ source: S, mapper: @escaping (X) -> (Y)) where X == S.Value {
        self.source = source.eraseToAnyLiveData()
        self.map = mapper
    }

    public func get() -> Y {
        map(self.source.get())
    }

    public func publisher() -> AnyPublisher<Y, Never> {
        self.source.publisher()
            .map(map)
            .eraseToAnyPublisher()
    }
}

public extension LiveData {
    func map<T>(_ mapper: @escaping (Value) -> T) -> MappedLiveData<Value,T> {
        MappedLiveData(self,mapper: mapper)
    }
}
