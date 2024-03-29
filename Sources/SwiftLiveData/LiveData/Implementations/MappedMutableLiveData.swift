//
//  MappedMutableLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public class MappedMutableLiveData<Mapper: ValueMapper>: MutableLiveData {
    private let source: AnyMutableLiveData<Mapper.X>
    private let mapper: Mapper

    init<S: MutableLiveData>(_ source: S, mapper: Mapper) where Mapper.X == S.Value {
        self.source = source.eraseToAnyMutableLiveData()
        self.mapper = mapper
    }

    public func get() -> Mapper.Y {
        mapper.map(self.source.get())
    }

    public func set(_ value: Mapper.Y) {
        self.source.set(mapper.map(value))
    }

    public func publisher() -> AnyPublisher<Mapper.Y, Never> {
        self.source.publisher()
            .map(mapper.map)
            .eraseToAnyPublisher()
    }
}


public extension MutableLiveData {
    func map<M: ValueMapper>(_ mapper: M) -> MappedMutableLiveData<M> where M.X == Self.Value{
        MappedMutableLiveData(self, mapper: mapper)
    }
}
