//
//  MappedLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

class MappedLiveData<X,Y>: LiveData {
    
    private let source: AnyLiveData<X>
    private let map: (X) -> (Y)

    init<S: LiveData>(_ source: S, mapper: @escaping (X) -> (Y)) where X == S.Value {
        self.source = source.eraseToAnyLiveData()
        self.map = mapper
    }

    func get() -> Y {
        map(self.source.get())
    }

    func publisher() -> AnyPublisher<Y, Never> {
        self.source.publisher()
            .map(map)
            .eraseToAnyPublisher()
    }
}

extension LiveData {
    func map<T>(_ mapper: @escaping (Value) -> T) -> MappedLiveData<Value,T> {
        MappedLiveData(self,mapper: mapper)
    }
}
