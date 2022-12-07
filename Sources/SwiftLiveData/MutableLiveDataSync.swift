//
//  MutableLiveDataSync.swift
//
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine


@propertyWrapper
public class MutableLiveDataSync<Value> {
    
    private let defaultValue: Value
    private var change: ObservableObjectPublisher?
    private var dataSource: AnyMutableLiveData<Value>?
    private var cancellable: AnyCancellable?

    public init<D: MutableLiveData>(wrappedValue: Value, dataSource: D) where D.Value == Value {
        self.defaultValue = wrappedValue
        self.dataSource = dataSource.eraseToAnyMutableLiveData()
        self.monitor()
    }
    
    public init(wrappedValue: Value) {
        self.defaultValue = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            return self.dataSource?.get() ?? defaultValue
        }
        set {
            self.dataSource?.set(newValue)
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
    
    public func set<D: MutableLiveData>(_ dataSource: D, change: ObservableObjectPublisher? = nil) where D.Value == Value {
        self.dataSource = dataSource.eraseToAnyMutableLiveData()
        self.change = change
        self.monitor()
    }

    public func set(_ change: ObservableObjectPublisher) {
        self.change = change
    }

    public static subscript<EnclosingSelf: ObservableObject>(
      _enclosingInstance object: EnclosingSelf,
      wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
      storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, MutableLiveDataSync<Value>>
    ) -> Value {
      get {
        return object[keyPath: storageKeyPath].wrappedValue
      }
      set {
          object[keyPath: storageKeyPath].change = object.objectWillChange as? ObservableObjectPublisher
          object[keyPath: storageKeyPath].wrappedValue = newValue
      }
    }
}
