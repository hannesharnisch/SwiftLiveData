//
//  LiveDataWrapper.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

public class LiveDataUtils {
    
}
public extension LiveDataUtils {
    class LiveDataWrapper<M: MutableLiveData>: LiveData {
        private let mutable: M
        
        init(_ mutable: M) {
            self.mutable = mutable
        }
        
        public func get() -> M.Value {
            return mutable.get()
        }
        
        public func publisher() -> AnyPublisher<M.Value, Never> {
            return mutable.publisher()
        }
    }
}
