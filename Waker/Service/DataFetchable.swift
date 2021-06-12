//
//  DataFetchable.swift
//  Waker
//
//  Created by Joe Ciou on 2021/6/11.
//

import Foundation
import Combine

protocol DataFetchable {
    associatedtype Model: Decodable
    
    func fetch() -> AnyPublisher<[Model], DataFetchableError>
}

class AnyDataFetchable<Model: Decodable>: DataFetchable {
    let currentData: [Model]
    
    init(initialData: [Model] = [Model]()) {
        self.currentData = initialData
    }
    
    func fetch() -> AnyPublisher<[Model], DataFetchableError> {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
}

enum DataFetchableError: Error {
    case networking(URLError)
    case decoding(Error)
}
