//
//  LiveDataSync.swift
//  
//
//  Created by Hannes Harnisch on 07.12.22.
//

import Foundation
import Combine


@propertyWrapper
class LiveDataSync<Value> {
    
    private let defaultValue: Value
    private var change: ObservableObjectPublisher?
    private var dataSource: AnyLiveData<Value>?
    private var cancellable: AnyCancellable?

    init<D: LiveData>(wrappedValue: Value, dataSource: D) where D.Value == Value {
        self.defaultValue = wrappedValue
        self.dataSource = dataSource.eraseToAnyLiveData()
        self.monitor()
    }
    
    init(wrappedValue: Value) {
        self.defaultValue = wrappedValue
    }

    var wrappedValue: Value {
        get {
            return self.dataSource?.get() ?? defaultValue
        }
    }

    var projectedValue: AnyPublisher<Value,Never>? {
        return dataSource?.publisher()
    }

    func monitor() {
        self.cancellable?.cancel()
        self.cancellable = self.dataSource?.publisher().receive(on: RunLoop.main).sink { _ in
            self.change?.send()
        }
    }
    
    func set<D: LiveData>(_ dataSource: D, change: ObservableObjectPublisher? = nil) where D.Value == Value {
        self.dataSource = dataSource.eraseToAnyLiveData()
        self.change = change
        self.monitor()
    }

    func set(_ change: ObservableObjectPublisher) {
        self.change = change
    }

    public static subscript<EnclosingSelf: ObservableObject>(
      _enclosingInstance object: EnclosingSelf,
      wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
      storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, LiveDataSync<Value>>
    ) -> Value {
      get {
        return object[keyPath: storageKeyPath].wrappedValue
      }
      set {
          object[keyPath: storageKeyPath].change = object.objectWillChange as? ObservableObjectPublisher
      }
    }
}
