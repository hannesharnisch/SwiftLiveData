//
//  BasicLiveData.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

class BasicLiveData<Value>: MutableLiveData {
    
    private let subject: CurrentValueSubject<Value, Never>
    
    init(value: Value) {
        self.subject = CurrentValueSubject(value)
    }
    
    func get() -> Value {
        self.subject.value
    }

    func set(_ value: Value) {
        self.subject.send(value)
    }

    func publisher() -> AnyPublisher<Value, Never> {
        self.subject.eraseToAnyPublisher()
    }
}
