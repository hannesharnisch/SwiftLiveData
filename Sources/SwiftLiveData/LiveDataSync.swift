//
//  LiveDataSync.swift
//  
//
//  Created by Hannes Harnisch on 07.12.22.
//

import Foundation
import Combine


@propertyWrapper
public class LiveDataSync<Value> {
    
    private let defaultValue: Value
    private var change: ObservableObjectPublisher?
    private var dataSource: AnyLiveData<Value>?
    private var cancellable: AnyCancellable?

    public init<D: LiveData>(wrappedValue: Value, dataSource: D) where D.Value == Value {
        self.defaultValue = wrappedValue
        self.dataSource = dataSource.eraseToAnyLiveData()
        self.monitor()
    }
    
    public init(wrappedValue: Value) {
        self.defaultValue = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            return self.dataSource?.get() ?? defaultValue
        }
    }

    public var projectedValue: AnyPublisher<Value,Never>? {
        return dataSource?.publisher()
    }

    private func monitor() {
        self.cancellable?.cancel()
        self.cancellable = self.dataSource?.publisher().receive(on: RunLoop.main).sink { _ in
            self.change?.send()
        }
    }
    
    public func set<D: LiveData>(_ dataSource: D, change: ObservableObjectPublisher? = nil) where D.Value == Value {
        self.dataSource = dataSource.eraseToAnyLiveData()
        self.change = change
        self.monitor()
    }

    public func set(_ change: ObservableObjectPublisher) {
        self.change = change
    }

    public static subscript<EnclosingSelf: ObservableObject>(
      _enclosingInstance object: EnclosingSelf,
      wrapped wrappedKeyPath: KeyPath<EnclosingSelf, Value>,
      storage storageKeyPath: KeyPath<EnclosingSelf, LiveDataSync<Value>>
    ) -> Value {
      get {
        return object[keyPath: storageKeyPath].wrappedValue
      }
    }
}
