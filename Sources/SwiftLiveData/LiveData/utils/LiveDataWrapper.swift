//
//  LiveDataWrapper.swift
//  
//
//  Created by Hannes Harnisch on 30.11.22.
//

import Foundation
import Combine

class LiveDataUtils {
    
}
extension LiveDataUtils {
    class LiveDataWrapper<M: MutableLiveData>: LiveData {
        private let mutable: M
        
        init(_ mutable: M) {
            self.mutable = mutable
        }
        
        func get() -> M.Value {
            return mutable.get()
        }
        
        func publisher() -> AnyPublisher<M.Value, Never> {
            return mutable.publisher()
        }
    }
}
